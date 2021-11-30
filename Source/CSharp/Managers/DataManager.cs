using Godot;
using System;

public class DataManager : Node
{
    int day = 0;
    int totalBugKills = 0;
    public int totalBugLeaks = 0;
    public int totalGoldEarned = 0;
    int totalFlowersHarvested = 0;
    int totalPeoniePlantsLost = 0;
    int totalFlowersSold = 0;

    int peoniesAlive = 0;

    [Signal]
    public delegate void OnDayChanged(int newDay);

    [Signal]
    public delegate void OnTotalBugKillsChanged(int amount);

    public void AddPeony()
    {
        peoniesAlive += 1;
    }

    public void RemovePeony()
    {
        peoniesAlive -= 1;
        totalPeoniePlantsLost++;
        if( peoniesAlive == 0)
        {
            var gameManager = GetNode<Node>("/root/GameManager");
            gameManager.Call("LoseGame");
        }
    }

    public override void _Ready()
    {
        var gameManager = GetNode<Node>("/root/GameManager");
        gameManager.Call("SetDataManager", new object[] { this });
        EmitSignal(nameof(OnDayChanged), new object[] { day });
        EmitSignal(nameof(OnTotalBugKillsChanged), new object[] { totalBugKills });
    }

    public string GetGameOverStats()
    {
        return $"Days Survived: {Day}\nBugs Killed: {TotalBugKills}\nBugs Leaked: {totalBugLeaks}\nTotal coins earned: {totalGoldEarned}\nTotal flowers harvested: {totalFlowersHarvested}\nTotal flowers sold: {totalFlowersSold}\nTotal Peonie  plants lost: {totalPeoniePlantsLost}";
    }

    public int Day
    {
        get { return day; }
        set { 
            day = value;
            EmitSignal(nameof(OnDayChanged), new object[] { value });
        }
    }

    public int TotalBugKills
    {
        get { return totalBugKills; }
        set { 
            totalBugKills = value;
            EmitSignal(nameof(OnTotalBugKillsChanged), new object[] { value });
        }
    }

    public void _on_AntWaveManager_OnAntKilled()
    {
        TotalBugKills += 1;
    }

}
