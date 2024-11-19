#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

bool g_firstStart;
int g_checkCount;

public Plugin myinfo = {
	name = "Server restart and Map reloader",
	author = "bauxite, rain",
	description = "Reloads current map when server is empty to prevent issues, also restarts periodically",
	version = "0.3.1",
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_firstStart = !late;
	return APLRes_Success;
}

public void OnMapStart()
{
	if(g_firstStart)
	{
		g_firstStart = false;
		CreateTimer(3.0, Timer_ReloadMap, _, TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{	
		CreateTimer(2341.0, Timer_ReloadMapIfEmptyServer, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action Timer_ReloadMap(Handle timer, any data)
{
	ReloadLevel();
	return Plugin_Stop;
}

public Action Timer_ReloadMapIfEmptyServer(Handle timer, any data)
{
	++g_checkCount;
	int playerCount = GetClientCount(true);
	
	if (playerCount <= 1)
	{
		if(g_checkCount <= 9)
		{
			ReloadLevel();
			return Plugin_Stop;
		}
		else
		{
			ServerCommand("_restart");
		}
	}

	return Plugin_Continue;
}

void ReloadLevel()
{
	char mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	ForceChangeLevel(mapName, "Empty server");
}
