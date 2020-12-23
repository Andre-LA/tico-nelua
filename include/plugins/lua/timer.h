#ifndef TICO_LUA_TIME_H
#define TICO_LUA_TIME_H

#include "../../tico.h"

int luaopen_timer(lua_State *L);

#endif

#if defined(TICO_LUA_IMPLEMENTATION)

static int tico_lua_get_fps(lua_State *L) {
  lua_pushnumber(L, tico_timer_get_fps());
  return 1;
}

static int tico_lua_get_delta(lua_State *L) {
  lua_pushnumber(L, tico_timer_get_delta());
  return 1;
}

int luaopen_timer(lua_State *L) {
  luaL_Reg reg[] = {
    {"fps", tico_lua_get_fps},
    {"delta", tico_lua_get_delta},
    {NULL, NULL}
  };
  luaL_newlib(L, reg);
//   luaL_register(L, NULL, reg);
//   lua_pushvalue(L, -1);

  return 1;
}

#endif
