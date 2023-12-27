#include <sourcemod>

int CheckCount;

public Plugin myinfo =
{
	name        = "NT Server Restart and Map Changer",
	author      = "Rain, bauxite",
	description = "Changes to nextmap when server is empty to prevent issues but also restarts periodically",
	version     = "0.1.0.R",
};

public void OnPluginStart()
{
	CreateTimer(2341.0, Timer_RotateMapIfEmptyServer, _, TIMER_REPEAT);
	CheckCount = 0;
}

public Action Timer_RotateMapIfEmptyServer(Handle timer, any data)
{
	int Count = GetClientCount(true);
	
	++CheckCount;
	
	if (Count <= 1)
	{
		char nextmap[PLATFORM_MAX_PATH];
		
		if (!GetNextMap(nextmap, sizeof(nextmap)))
		{
			ThrowError("Failed to get next map");
		}
		
		if (CheckCount <= 24)
		{
			ForceChangeLevel(nextmap, "Rotate map due to empty server.");
		}
		else
		{
			ServerCommand("_restart");
		}
	}
	
	return Plugin_Continue;
}
