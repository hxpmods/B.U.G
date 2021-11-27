using Godot;
using System;

public class ResourceManager : Node
{
    [Export]
    public float peonyToGoldRate = 1.0f;

    public override void _Ready()
    {
        var gameManager = GetNode<Node>("/root/GameManager");
        gameManager.Call("SetResourceManager", new object[] { this });
    }

    public void AddResource(string resName, int amount)
    {
        if (this.HasNode(resName))
        {
            var node = this.GetNode(resName);
            node.Call("SetAmount", new object[] { (int)node.Get("amount") + amount });
        }
    }

    public bool CanAfford(Node resource)
    {
        string resName = resource.Name;
        int resAmount = (int)resource.Get("amount");

        if (this.HasNode(resName))
        {
            var node = this.GetNode(resName);
            return resAmount <= (int)node.Get("amount");
        }
        return false;
    }

    public bool CanAffordCosts(Node[] costs)
    {
        foreach (Node cost in costs)
        {
            bool isSuccess = CanAfford(cost);
            if (!isSuccess)
            {
                return false;
            }
        }
        return true;
    }

    public void PreviewCosts(Node[] costs, bool isCost = true)
    {
        ClearCosts();

        foreach (Node cost in costs)
        {
            if (HasNode(cost.Name))
            {
                var node = GetNode(cost.Name);
                var amount = (int)cost.Get("amount");
                if (isCost) amount = -amount;
                node.EmitSignal("OnPreviewAmountChanged", amount);
            }
        }
    }

    public void ClearCosts()
    {
        foreach (Node child in GetChildren())
        {
            child.EmitSignal("OnPreviewAmountChanged", 0);
        }
    }


    public bool Spend(Node resource)
    {
        string resName = resource.Name;
        int resAmount = (int)resource.Get("amount");

        if (this.HasNode(resName))
        {
            var node = this.GetNode(resName);
            if(CanAfford(resource))
            {
                node.Call("SetAmount", new object[] { (int)node.Get("amount") - resAmount });
                return true;
            }
        }

        return false;
    }

}
