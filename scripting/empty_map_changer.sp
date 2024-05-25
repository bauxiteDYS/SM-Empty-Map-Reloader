#include <sourcemod>

bool g_firstStart;
bool g_lateLoad;

public Plugin myinfo =
{
	name        = "Empty Map Changer",
	author      = "Rain, bauxite",
	description = "Changes to nextmap when server is empty to prevent issues",
	version     = "0.1.5",
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	g_lateLoad = late;
	return APLRes_Success;
}

public void OnPluginStart()
{
	if(g_lateLoad)
	{
		g_firstStart = false;
	}
	else
	{
		g_firstStart = true;
	}
}

public void OnMapStart()
{
	if(g_firstStart)
	{
		g_firstStart = false;
		ChangeLevel();
	}
		
	CreateTimer(2341.0, Timer_RotateMapIfEmptyServer, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_RotateMapIfEmptyServer(Handle timer, any data)
{
	int playerCount = GetClientCount(true);
	
	if (playerCount <= 1)
	{
		ChangeLevel();

		return Plugin_Handled;
	}

	return Plugin_Continue;
}

void ChangeLevel()
{
	char nextmap[PLATFORM_MAX_PATH];

	if (!GetNextMap(nextmap, sizeof(nextmap)))
	{
		ThrowError("Failed to get next map");
	}

	ForceChangeLevel(nextmap, "Empty server.");
}
