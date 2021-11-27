using Godot;
using System;

public class Ant : Sprite
{
    [Signal]
    public delegate void OnHealthChanged();
    [Signal]
    public delegate void OnAntDie( Ant ant);

    public Vector2 lastKnownPos = Vector2.Zero;

    enum DeathType
    {
        NotDead, Violent, NonViolent
    }

    Vector2 velocity = Vector2.Zero;
    Vector2 desiredDirection = Vector2.Zero;

    [Export]
    public string spawnGroup = "BasicAnt";

    [Export]
    float maxSpeed = 30;
    [Export]
    float wanderStrength = 0.4f;
    [Export]
    float goalStrength = 0.4f;
    [Export]
    float positivePheremoneStrength = 0.6f;
    [Export]
    float negativePheremoneStrength = 0.8f;
    [Export]
    float maxHealth = 10;

    public float health;

    Random ran = new Random();

    Sensor leftSensor = new Sensor((Vector2.Right + Vector2.Up).Normalized() * 40 ,3);
    Sensor centerSensor = new Sensor(Vector2.Right * 60, 3);
    Sensor rightSensor = new Sensor((Vector2.Right+ Vector2.Down).Normalized()* 40, 3);
    DeathType deathQueued = DeathType.NotDead;

    [Export]
    public Node2D goal;
    PheremoneMap pheremoneManager;

    public class Sensor
    {
        public Vector2 offsetPos;
        public float radius = 10;
        Ant ant;

        public float value = 0;

        public Sensor(Vector2 offsetPos, float radius)
        {
            this.offsetPos = offsetPos;
            this.radius = radius;
        }

        public void SetAnt( Ant ant)
        {
            this.ant = ant;
        }

        public void Process()
        {
            if( ant != null && ant.IsInsideTree())
            {
                Sense();
            }
        }

        private void Sense()
        {
           PheremoneMap pm = ant.pheremoneManager;
           value = pm.GetAverageFromRect(pm.ToLocal(ant.GlobalPosition + offsetPos), radius);
        }
    }

    public override void _Ready()
    {
        leftSensor.SetAnt(this);
        centerSensor.SetAnt(this);
        rightSensor.SetAnt(this);

        Reset();
    }

    public void Reset()
    {
        health = maxHealth;
        deathQueued = DeathType.NotDead;
    }

    public bool Damage(float amount)
    {
        bool lethal = false;
        health = Mathf.Clamp(health - amount, 0, maxHealth);
        if (health == 0) { 
            deathQueued = DeathType.Violent;
            lethal = true;
        }
        EmitSignal(nameof(OnHealthChanged));
        return lethal;
    }

    public override void _Process( float delta)
    {
        if (this.IsInsideTree())
        {
            Vector2 goalDirection = GetGoalDirection();

            desiredDirection = (desiredDirection + goalDirection * goalStrength).Normalized();

            var randomDirection = new Vector2((float)(-1 + 2 * ran.NextDouble()), (float)(-1 + 2 * ran.NextDouble())).Normalized();
            desiredDirection = (desiredDirection + randomDirection * wanderStrength).Normalized();

            SensePheremones();
            desiredDirection = (desiredDirection + (positivePheremoneStrength * GetPositivePheremoneHeading())).Normalized();

            desiredDirection = (desiredDirection + (negativePheremoneStrength * GetNegativePheremoneHeading())).Normalized();

            MoveToDesiredDirection(delta);
            lastKnownPos = GlobalPosition;
            CheckDeath();
        }

    }

    private void CheckDeath()
    {
        if (deathQueued == DeathType.Violent)
        {
            this.Die();
        }
        else if (deathQueued == DeathType.NonViolent)
        {
            this.Die(false);
        }

    }

    public void _on_Timer_timeout()
    {
        var localPos = pheremoneManager.ToLocal(Position);
        pheremoneManager.AddQueuedPheremone((int)localPos.x, (int)localPos.y, 0.05f);
    }

    private void MoveToDesiredDirection(float delta)
    {
        var steerMultiplier = 2.0f;
        var desiredVelocity = desiredDirection * maxSpeed;
        var desiredSteering = (desiredVelocity - velocity) * steerMultiplier;
        var acceleration = desiredSteering / 1f;

        velocity = velocity + acceleration * delta;

        var nextFrameTarget = this.Position;
        nextFrameTarget = BounceIfNeeded(nextFrameTarget, velocity * delta);

        this.LookAt(nextFrameTarget);

        this.Position = nextFrameTarget;

    }

    private void FindGoal()
    {
        var possibleTargets = GetTree().GetNodesInGroup("food");

        Node2D bestCandidate = null;
        float? bestCandidateLength = null;
        foreach (Node2D possibleTarget in possibleTargets)
        {
            if (possibleTarget.IsInsideTree())
            {
                var distance = possibleTarget.GlobalPosition.DistanceTo(this.GlobalPosition) / (float)possibleTarget.Get("strength");
                if (bestCandidateLength == null || distance < bestCandidateLength)
                {
                    bestCandidate = possibleTarget;
                    bestCandidateLength = distance;
                }
            }
        }
        goal = bestCandidate;
    }

    private Vector2 GetGoalDirection()
    {
        Vector2 dir = Vector2.Zero;
        FindGoal();


        if (goal == null )
        {
            return dir;
        }


        if (goal != null)
        {           
            if (!IsInstanceValid(goal))
            {
                FindGoal();
            }

            if (goal != null)
            {
                dir = goal.GlobalPosition - this.GlobalPosition;

                if (dir.Length() < 5.0)
                {
                    goal.GetParent().Call("Damage", 30);
                    deathQueued = DeathType.NonViolent;
                }
            }
        }
        return dir.Normalized();
    }

    private void Die( bool violent = true)
    {
        SetProcess(false);
        var localPos = pheremoneManager.ToLocal(Position);
        if (violent) pheremoneManager.AddQueuedPheremone((int)localPos.x, (int)localPos.y, 0.1f, true);
        //this.GetParent().SetCurrentAntCount(get_parent().currentAntCount - 1);
        EmitSignal(nameof(OnAntDie),new object[] {this});
        //this.QueueFree();
    }

    private Vector2 BounceIfNeeded(Vector2 startPos, Vector2 moveVec)
    {

        var targetPosition = startPos + moveVec;


        if (targetPosition.x > pheremoneManager.size.x * pheremoneManager.Scale.x)
        {
            moveVec = FlipXHeading(moveVec);
        }
        if (targetPosition.y > pheremoneManager.size.y * pheremoneManager.Scale.y)
        {
            moveVec = FlipYHeading(moveVec);
        }

        if (targetPosition.x < 0) {
            moveVec = FlipXHeading(moveVec);
        }

        if (targetPosition.y < 0) {
            moveVec = FlipYHeading(moveVec);
        }
        return startPos + moveVec;
    }

    private Vector2 FlipXHeading(Vector2 moveVec)
    {
        moveVec.x = -moveVec.x;
        velocity.x = -velocity.x;
        desiredDirection.x = -desiredDirection.x;

        return moveVec;
    }

    private Vector2 FlipYHeading(Vector2 moveVec)
    {
        moveVec.y = -moveVec.y;
        velocity.y = -velocity.y;
        desiredDirection.y = -desiredDirection.y;

        return moveVec;
    }

    private void SensePheremones()
    {
        leftSensor.Process();
        centerSensor.Process();
        rightSensor.Process();
    }

    private Vector2 GetPositivePheremoneHeading()
    {
        if (centerSensor.value > Mathf.Max(leftSensor.value, rightSensor.value)) {
            return Vector2.Right * this.Transform.y;
        }
        else if (leftSensor.value > rightSensor.value)
        {
            return Vector2.Up * this.Transform.y;
        }
        else if (rightSensor.value > leftSensor.value)
        {
            return Vector2.Down * this.Transform.y;
        }
        return Vector2.Zero;
    }

    private Vector2 GetNegativePheremoneHeading()
    {

        float pheremonedangerLeft = 0;
        float pheremonedangerRight = 0;
        float pheremonedangerCenter = 0;

        if (leftSensor.value < 0) pheremonedangerLeft = -leftSensor.value;
        if (centerSensor.value < 0) pheremonedangerCenter = -centerSensor.value;
        if (rightSensor.value < 0) pheremonedangerRight = -rightSensor.value;

        if (pheremonedangerCenter > Mathf.Max(pheremonedangerLeft, pheremonedangerRight))
        {
            return -Vector2.Right * this.Transform.y;
        }
        else if (pheremonedangerLeft > pheremonedangerRight)
        {
            return -Vector2.Up * this.Transform.y;
        }
        else if (pheremonedangerRight > pheremonedangerLeft)
        {
            return -Vector2.Down * this.Transform.y;
        }
        return Vector2.Zero;
    }

}
