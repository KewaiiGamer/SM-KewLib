public int Native_IsValidClient(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	bool bAllowBots = view_as<bool>(GetNativeCell(2));
	bool bAllowDead = view_as<bool>(GetNativeCell(3));
	if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!IsPlayerAlive(client) && !bAllowDead))
	{
		return false;
	}
	return true;
}

public int Native_HasClientFlag(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	char flagString[64];
	GetNativeString(2, flagString, sizeof(flagString));
	AdminId admin = view_as<AdminId>(GetUserAdmin(client));
	if (admin != INVALID_ADMIN_ID){
		int flags = ReadFlagString(flagString);
		for (int i = 0; i <= 20; i++){
			if (flags & (1<<i))
			{
				if(GetAdminFlag(admin, view_as<AdminFlag>(i))){
					return true;
				}
			}
		}
	}
	return false;
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("HasClientFlag", Native_HasClientFlag);
	CreateNative("IsValidClient", Native_IsValidClient);
	return APLRes_Success;
}