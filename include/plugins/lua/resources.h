#include "../../tico.h"

static int tico_lua_resource_new(lua_State *L) {
	tc_Resource *resource = lua_newuserdata(L, sizeof(*resource));
	luaL_setmetatable(L, RESOURCE_CLASS);

	tico_resource_init(resource);

	const char *type = luaL_optstring(L, 1, "");
	const char *name = luaL_optstring(L, 2, "");
	const char *path = luaL_optstring(L, 3, "");
	strcpy(resource->type, type);
	strcpy(resource->name, name);
	strcpy(resource->path, path);

	return 1;
}

static int luaopen_resource(lua_State *L) {
	luaL_Reg reg[] = {
		// {"__call", tico_lua_tileset_new},
		// {"draw", tico_lua_tileset_draw},
		// {"get_rect", tico_lua_tileset_get_rect},
		// {"from_bitmask", tico_lua_tileset_from_bitmask},
		// // {"get_rect_from_bitmask", },
		// {"__gc", tico_lua_tileset__gc},
		{NULL, NULL}
	};

	// luaL_newlib(L, reg);

	luaL_newmetatable(L, RESOURCE_CLASS);
  luaL_setfuncs(L, reg, 0);
  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index");

	return 1;
}

static int tico_lua_resources_init(lua_State *L) {
	int top = lua_gettop(L);
	// TRACELOG("%d", top);
	const char *path = luaL_optstring(L, 1, NULL);
	// tico_resources_init(&Core.resources, path);
	// if (top <= 0) tico_resources_init(&Core.resources);	
	// else {
	// 	const char *path = luaL_checkstring(L, 1);
	// 	tico_resources_load(&Core.resources, path);
	// }
	

	return 0;
}

static int tico_lua_resources_load(lua_State *L) {
	const char *type = luaL_checkstring(L, 1);
	const char *name = luaL_checkstring(L, 2);
	const char *path = luaL_checkstring(L, 3);

	// tico_resources_load(&Core.resources, type, name, path);

	return 0;
}

static int tico_lua_resources_default_loaders(lua_State *L) {
  // tico_resources_default_loaders(&Core.resources);
  return 0;
}

static int tico_lua_resources_add(lua_State *L) {
	const char *type = luaL_checkstring(L, 1);
	const char *name = luaL_checkstring(L, 2);
	void *data = lua_touserdata(L, 3);
	if (!data) return 0;

	// tc_Image *image = luaL_testudata(L, 3, IMAGE_CLASS);
	// tc_Tileset *tileset = luaL_testudata(L, 3, TILESET_CLASS);
	// tc_Tilemap *tilemap = luaL_testudata(L, 3, TILEMAP_CLASS);
	// tc_Resource res = {0};
	// strcpy(res.name, name);
	// // res.type = TIC_RESOURCE_LUA;
	// res.lua = tc_true;
	// res.L = L;
	// int resp = 0;
	// if (image) {
	// 	res.data = image;
	// 	// res.type |= TIC_RESOURCE_IMAGE;
	// 	strcpy(res.type, "image");
	// } else if (tileset) {
	// 	res.data = tileset;
	// 	// res.type |= TIC_RESOURCE_TILESET;
	// 	strcpy(res.type, "tileset");
	// } else if (tilemap) {
	// 	res.data = tilemap;
	// 	// res.type |= TIC_RESOURCE_TILEMAP;
	// 	strcpy(res.type, "tilemap");
	// }
	tc_Resource res = {0};
	
	int resp = 0;
	strcpy(res.name, name);
	strcpy(res.type, type);
	res.data = data;

	
	// resp = tico_resources_add(&Core.resources, type, name, &res);
	// if () {
	// 	resp = 1;
		
	// }

	lua_pushboolean(L, resp);

	return 1;
}

static int tico_lua_resources_get(lua_State *L) {

	const char *type = luaL_checkstring(L, 1);
	const char *name = luaL_checkstring(L, 2);

	// tico_resources_get(&Core.resources, type, name);
	tico_plugin_resources_get(type, name);
	

	return 1;
}

static int tico_lua_resources_get_by_key(lua_State *L) {

	const char *key = luaL_checkstring(L, 1);

	// lua_pop(L, 1);
	tico_plugin_resources_get_by_key(key);

	return 1;
}

static int tico_lua_resources_store(lua_State *L) {
	// tico_resources_store(&Core.resources);

	return 0;
}

int luaopen_resources(lua_State *L) {
	luaL_Reg reg[] = {
		{"init", tico_lua_resources_init},
    {"default", tico_lua_resources_default_loaders},
		{"add", tico_lua_resources_add},
		{"load", tico_lua_resources_load},
		{"store", tico_lua_resources_store},
		{"get", tico_lua_resources_get},
		{"getByKey", tico_lua_resources_get_by_key},
		{NULL, NULL}
	};

	luaL_newlib(L, reg);

	return 1;
}
