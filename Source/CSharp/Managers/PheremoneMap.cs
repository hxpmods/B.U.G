using Godot;
using System;
using System.Collections.Generic;

public class PheremoneMap : Sprite
{

    Image image;
    ImageTexture imageTexture;
    Random ran = new Random();

    float timeSinceDispersal = 0;
    

    Queue<QueuedPheremone> pheremoneQueue = new Queue<QueuedPheremone>();

    [Export]
    public Vector2 size = new Vector2(320, 320);
    [Export]
    public float disperseAmount = 0.5f;
    [Export]
    public float disperseRate = 1.0f;
    [Export]
    public float negativePheremoneDispersalRatio = 0.5f;

    class QueuedPheremone
    {
        public Vector2 pos;
        public float amount;
        public bool negative;

        public QueuedPheremone(Vector2 pos, float amount, bool negative = false)
        {
            this.pos = pos;
            this.amount = amount;
            this.negative = negative;
        }
    }

    public override void _Ready()
    {
        PrepareTexture();
    }

    public override void _Process(float delta)
    {
        image.Lock();
        
        timeSinceDispersal += delta;
        if (timeSinceDispersal > disperseRate) {
            timeSinceDispersal -= disperseRate;
            ProcessPheremoneDispersion();
        }

        ProcessPheremoneQueue();
        

        image.Unlock();
        imageTexture.CreateFromImage(image, 0);
    }


    private void ProcessPheremoneQueue()
    {
        if( pheremoneQueue.Count > 0)
        {
            foreach (var pheremone in pheremoneQueue)
            {
                AddPheremone((int)pheremone.pos.x, (int)pheremone.pos.y, pheremone.amount, pheremone.negative);
            }
            pheremoneQueue.Clear();
        }
    }

    private void ProcessPheremoneDispersion()
    {
        for (int x = 0; x< size.x; x++) {
            for (int y = 0; y < size.y; y++)
            {
                Color oldcol = image.GetPixel(x,y);
                Color newCol = oldcol;

                newCol.g = Mathf.Max(newCol.g -disperseAmount* 0.01f, 0);
                newCol.r = Mathf.Max(newCol.r - disperseAmount*negativePheremoneDispersalRatio* 0.01f, 0);
                image.SetPixel(x, y, newCol);
            }
        }

    }

    private void PrepareTexture()
    {
        imageTexture = new ImageTexture();
        image = new Image();
        image.Create((int)size.x, (int)size.y, false, Image.Format.Rgbah);

        var col = Color.ColorN("black");
        image.Fill(col);

        imageTexture.CreateFromImage(image, 0);
        this.Texture = imageTexture;
    }
    
    private void AddPheremone(int x, int y, float strength, bool negative = false)
    {

        var oldcol = image.GetPixel(x, y);
        Color col;

        if (!negative)
        {
            var newstrength = Mathf.Min(oldcol.g + strength, 0.95f);
            col = new Color(oldcol.r, newstrength, oldcol.b, oldcol.a);
        }
        else
        {
            var newstrength = Mathf.Min(oldcol.r + strength, 0.95f);
            col = new Color(newstrength, oldcol.g, oldcol.b, oldcol.a);
        }

        image.SetPixel(x, y, col);
        imageTexture.CreateFromImage(image, 0);
    }

    public void AddQueuedPheremone(int x, int y, float strength, bool negative = false)
    {
        pheremoneQueue.Enqueue(new QueuedPheremone(new Vector2(x, y), strength, negative));
    }

    public Vector2 GetRandomPosInRange()
    {
        var x = ran.Next(0, (int)(size.x * this.Scale.x));
        var y = ran.Next(0, (int)(size.y * this.Scale.y));

        return new Vector2(x, y) + this.GlobalPosition;
    }

    public float GetAverageFromRect(Vector2 position, float size)
    {
        image.Lock();
        position.x = position.x - size * 0.5f;
        position.y = position.y - size * 0.5f;

        var rect = new Rect2(position, new Vector2(size, size));
        var averagePheremone = 0f;

        int cellsSkipped = 0;

        for(int x =0; x < size; x++)
        {
            for (int y = 0; x < size; x++)
            {
                int currx = x + (int)position.x;
                int curry = y + (int)position.y;

                if (currx < 0 || currx > this.size.x-1 || curry < 0 || curry > this.size.y-1)
                {
                    cellsSkipped += 1;
                }
                else
                {
                    var col = image.GetPixel(currx, curry);
                    averagePheremone += col.g - col.r * 2;
                }
            }
        }

        image.Unlock();
        averagePheremone /= (size * size) - cellsSkipped;
        return averagePheremone;
    }

}
