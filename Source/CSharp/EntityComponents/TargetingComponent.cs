using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
class TargetingComponent : Node2D
{
    [Export]
    public string targetingGroup;
    [Export]
    public NodePath customTargetPath = null;

    public Node2D currentTarget;
    List<Node2D> possibleTargets = new List<Node2D>();

    public enum TargetingMode
    {
        CloseToEntity, CloseToGoal, HighestHealth
    }

    [Export]
    public TargetingMode targetingMode = TargetingMode.CloseToEntity;

    public override void _Process( float delta)
    {
        RecalculateTarget();
        if (currentTarget != null)
        {
            if (IsInstanceValid(currentTarget))
            {
                if (currentTarget.IsInsideTree())
                {
                    Node2D data = (Node2D)Owner.Call("GetEntityData");
                    float radius = (float)data.Call("GetRadius");
                    if (currentTarget.GlobalPosition.DistanceTo(this.GlobalPosition) > radius)
                    {
                        currentTarget = null;
                    }
                }
                else
                {
                    currentTarget = null;
                }
            }
            else
            {
                currentTarget = null;
            }
        }
    }


    private void RecalculateTarget()
    {
        possibleTargets.Clear();

        Area2D targetArea;

        if(customTargetPath == null)
        {
            targetArea = GetNode<Area2D>("Area2D");
        }
        else
        {
            targetArea = GetNode<Area2D>(customTargetPath);
        }


        foreach (Area2D area in targetArea.GetOverlappingAreas())
        {
            if (area.HasMethod("GetEntity"))
            {
                var entity = (Node2D)area.Call("GetEntity");
                if (entity.IsInGroup(targetingGroup))
                {
                    possibleTargets.Add(entity);
                }
            }
        }
        if (possibleTargets.Count() > 0)
        {
            var target = GetBestTarget();
            if (target != null)
            {
                currentTarget = target;
            }
        }
    }

    private Node2D GetBestTarget()
    {
        switch (targetingMode)
        {
            case TargetingMode.CloseToEntity:
                return GetClosestTarget();
            case TargetingMode.CloseToGoal:
                return GetTargetClosestToGoal();
            case TargetingMode.HighestHealth:
                return GetTargetHighestHealth();
        }
        return GetClosestTarget();
    }

    private Node2D GetTargetClosestToGoal()
    {
        Node2D bestCandidate = null;
        float? bestCandidateLength = null;
        foreach (Node2D possibleTarget in possibleTargets)
        {
            if (possibleTarget.IsInsideTree())
            {
                if (possibleTarget as Ant != null)
                {
                    Ant target = (Ant)possibleTarget;
                    if (target.goal != null)
                    {
                        var distance = target.GlobalPosition.DistanceTo(target.goal.GlobalPosition);
                        if (bestCandidateLength == null || distance < bestCandidateLength)
                        {
                            bestCandidate = target;
                            bestCandidateLength = distance;
                        }
                    }
                }
            }
        }
        return bestCandidate;
    }

    private Node2D GetTargetHighestHealth()
    {
        Node2D bestCandidate = null;
        float? bestCandidateLength = null;
        foreach (Node2D possibleTarget in possibleTargets)
        {
            if (possibleTarget.IsInsideTree())
            {
                if (possibleTarget as Ant != null)
                {
                    Ant target = (Ant)possibleTarget;
                    var score = target.health;
                    if (bestCandidateLength == null || score > bestCandidateLength)
                        {
                            bestCandidate = target;
                            bestCandidateLength = score;
                        }
                    
                }
            }
        }
        return bestCandidate;
    }

    private Node2D GetClosestTarget()
    {
        Node2D bestCandidate = null;
        float? bestCandidateLength = null;
        foreach(Node2D possibleTarget in possibleTargets)
        {
            if(possibleTarget.IsInsideTree())
            {
                var distance = possibleTarget.GlobalPosition.DistanceTo(this.GlobalPosition);
                if (bestCandidateLength == null || distance < bestCandidateLength)
                {
                    bestCandidate = possibleTarget;
                    bestCandidateLength = distance;
                }
            }
        }
        return bestCandidate;
    }

    public bool HasValidTarget()
    {
        return currentTarget!=null && IsInstanceValid(currentTarget) && currentTarget.IsInsideTree();
    }
}

