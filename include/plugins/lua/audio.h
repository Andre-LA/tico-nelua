#ifndef TICO_LUA_AUDIO_H
#define TICO_LUA_AUDIO_H

#include "../../tico.h"

TIC_API int luaopen_audio(lua_State *L);

#endif

#if defined(TICO_LUA_IMPLEMENTATION)

static int tico_lua_new_sound(lua_State *L) {
  const char *filename = luaL_checkstring(L, 1);
  tc_Sound *sound = lua_newuserdata(L, sizeof(tc_Sound));
  luaL_setmetatable(L, SOUND_CLASS);
  *sound = tico_sound_load(filename, 0);

  return 1;
}

static int tico_lua_play_sound(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  tico_sound_play(*sound);

  return 0;
}

static int tico_lua_stop_sound(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  tico_sound_stop(*sound);

  return 0;
}

static int tico_lua_pause_sound(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  tico_sound_pause(*sound);

  return 0;
}

static int tico_lua_sound_volume(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  float volume = luaL_optnumber(L, 2, sound->audioBuffer->volume);
  tico_sound_set_volume(*sound, volume);

  lua_pushnumber(L, volume);
  return 1;
}

static int tico_lua_sound_is_playing(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  int playing = tico_sound_is_playing(*sound);
  lua_pushboolean(L, playing);
  return 1;
}

static int tico_lua_sound_is_paused(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  int paused = tico_sound_is_paused(*sound);
  lua_pushboolean(L, paused);
  return 1;
}

static int tico_lua_destroy_sound(lua_State *L) {
  tc_Sound *sound = luaL_checkudata(L, 1, SOUND_CLASS);
  tico_sound_unload(*sound);

  return 0;
}

static int luaopen_sound(lua_State *L) {
  luaL_Reg reg[] = {
    {"play", tico_lua_play_sound},
    {"stop",  tico_lua_stop_sound},
    {"pause", tico_lua_pause_sound},
    {"volume", tico_lua_sound_volume},
    {"isPlaying", tico_lua_sound_is_playing},
    {"isPaused", tico_lua_sound_is_paused},
    {"__gc", tico_lua_destroy_sound},
    {NULL, NULL}
  };

  luaL_newmetatable(L, SOUND_CLASS);
  luaL_setfuncs(L, reg, 0);
  lua_pushvalue(L, -1);
  lua_setfield(L, -2, "__index");

  return 1;
}

static int tico_lua_set_master_volume(lua_State *L) {
  float volume = luaL_checknumber(L, 1);
  tico_audio_set_master_volume(volume);
  return 0;
}

int luaopen_audio(lua_State *L) {
  luaL_Reg reg[] = {
    {"newSound", tico_lua_new_sound},
    {"setVolume", tico_lua_set_master_volume},
    {NULL, NULL}
  };

  luaL_newlib(L, reg);
//   luaL_register(L, NULL, reg);
//   lua_pushvalue(L, -1);

  return 1;
}

#endif
