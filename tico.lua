--[[ This Source Code Form is subject to the terms of the Mozilla Public
     License, v. 2.0. If a copy of the MPL was not distributed with this
     file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

package.path = package.path .. ';./nelua-decl/?.lua'

local nldecl = require'nldecl'

local maps = {
  'map_fieldtype_t',
  'map_field_t',
  'map_anim_t',
  'map_plugin_t',
  'map_deps_t',
  'map_resource_t',
  'map_resref_t',
  'map_resplugin_t',
  'map_editorplugin_t',
  'map_editorwindow_t',
  'map_object_t',
  'map_void_t',
  'map_str_t',
  'map_int_t',
  'map_char_t',
  'map_float_t',
  'map_double_t'
}

local vecs = {
  'vec_canvas_t',
  'vec_void_t',
  'vec_str_t',
  'vec_int_t',
  'vec_char_t',
  'vec_float_t',
  'vec_double_t'
}

local lists = {
  'list_resdep_t',
  'list_int_t',
  'list_char_t',
  'list_str_t',
  'list_float_t'
}

local stacks = {
  'stack_canvas_t',
  'stack_shader_t',
  'stack_matrix_t'
}

local function gen_records(from)
  local result = {}

  for i = 1, #from do
    local Tname = from[i]

    table.insert(result, string.format(
      'local %s: type <cimport, nodecl> = @record{}',
      Tname
    ))
  end

  return table.concat(result, '\n')
end

local function gen_math_op_overloading()
  local result = {}

  local vec_op_template = table.concat( -- Vec1 will be replaced as Vec2, Vec3, ..., the same goes for vecN
    {
    "function tc_VecN.__eq(a: tc_VecN, b: tc_VecN): boolean <cimport'tico_vecN_equals', nodecl> end",
    "function tc_VecN.__len(v: tc_VecN): float32 <cimport'tico_vecN_len', nodecl> end",
    "function tc_VecN.__add(a: tc_VecN, b: tc_VecN): tc_VecN <inline> tico.vecN_add(&a, a, b) return a end",
    "function tc_VecN.__sub(a: tc_VecN, b: tc_VecN): tc_VecN <inline> tico.vecN_sub(&a, a, b) return a end",
    "function tc_VecN.__mul(a: tc_VecN, n: float32): tc_VecN <inline> tico.vecN_mul(&a, a, n) return a end",
    "function tc_VecN.__div(a: tc_VecN, n: float32): tc_VecN <inline> tico.vecN_div(&a, a, n) return a end"
    },
    '\n'
  )

  -- TODO: investigate and add others (like tc_Matrix)

  for i = 2, 4 do
    table.insert(result, string.gsub(vec_op_template, '([vV]ec)N', '%1'..i) .. '\n')
  end

  return table.concat(result, '\n')
end

nldecl.include_names = {
  '^tico_',
  '^tc_',
  '^TIC_',
}

nldecl.exclude_names = {
  '_internal$'
}

nldecl.prepend_code = table.concat(
{

[=[
##[[
  if not TICO.SHARED then
    cflags('-L '..TICO.L)

    cflags('-I '..TICO.I.include)
    cflags('-I '..TICO.I.external)

    linklib'tico_lib'
    linklib'glfw'
    linklib'gl3w'
    linklib'GL'
    linklib'lua'
    linklib'cimgui'
    linklib'dl'
    linklib'X11'
    linklib'pthread'
    linklib'stdc++'
  end

  cinclude'<tico.h>'
]]

local stbtt_fontinfo: type <cimport, nodecl> = @record{}
local cJSON: type <cimport, nodecl> = @record{}
local lua_State: type <cimport, nodecl> = @record{}
local LuaFunction: type <cimport, nodecl> = @function(*lua_State): cint
local map_base_t <cimport, nodecl> = @record{}
local ma_decoder <cimport, nodecl> = @record{}
local GLFWcursor <cimport, nodecl> = @record{}
local GLFWwindow <cimport, nodecl> = @record{}
local ImGuiWindowFlags_ <cimport, nodecl> = @record{}

]=],
table.concat(
  {
    gen_records(maps),
    gen_records(vecs),
    gen_records(lists),
    gen_records(stacks)
  },
  '\n'
),
"\nglobal tico = @record{}\n\n"

}, '\n')

nldecl.append_code = table.concat(

{
[=[

-- export records
global tico.Tileset: type = @tc_Tileset
global tico.Tilemap: type = @tc_Tilemap
global tico.Camera: type = @tc_Camera
global tico.Animation: type = @tc_Animation
global tico.Sprite: type = @tc_Sprite
global tico.Timer: type = @tc_Timer
global tico.Plugin: type = @tc_Plugin
global tico.PluginModule: type = @tc_PluginModule
global tico.Lua: type = @tc_Lua
global tico.ResourceDep: type = @tc_ResourceDep
global tico.Resource: type = @tc_Resource
global tico.ResourcePlugin: type = @tc_ResourcePlugin
global tico.ResourceManager: type = @tc_ResourceManager
global tico.PanelWidget: type = @tc_PanelWidget
global tico.GridWidget: type = @tc_GridWidget
global tico.Object: type = @tc_Object
global tico.ObjectWidget: type = @tc_ObjectWidget
global tico.GridTool: type = @tc_GridTool
global tico.EditorFolder: type = @tc_EditorFolder
global tico.EditorPlugin: type = @tc_EditorPlugin
global tico.EditorWindow: type = @tc_EditorWindow
global tico.Editor: type = @tc_Editor
global tico.AudioData: type = @tc_AudioData
global tico.AudioBuffer: type = @tc_AudioBuffer
global tico.Sound: type = @tc_Sound
global tico.Vertex: type = @tc_Vertex
global tico.DrawCall: type = @tc_DrawCall
global tico.Batch: type = @tc_Batch
global tico.Render: type = @tc_Render
global tico.Graphics: type = @tc_Graphics
global tico.Window: type = @tc_Window
global tico.Input: type = @tc_Input
global tico.Config: type = @tc_Config
global tico.Core: type = @tc_Core
global tico.Rect: type = @tc_Rect
global tico.Rectf: type = @tc_Rectf
global tico.Circle: type = @tc_Circle
global tico.Circlef: type = @tc_Circlef
global tico.Color: type = @tc_Color
global tico.Texture: type = @tc_Texture
global tico.Image: type = @tc_Image
global tico.Canvas: type = @tc_Canvas
global tico.Shader: type = @tc_Shader
global tico.CharacterInfo: type = @tc_CharacterInfo
global tico.Font: type = @tc_Font
global tico.Vec2: type = @tc_Vec2
global tico.Vec3: type = @tc_Vec3
global tico.Vec4: type = @tc_Vec4
global tico.Matrix: type = @tc_Matrix
global tico.Filesystem: type = @tc_Filesystem
global tico.MetaFn: type = @tc_MetaFn
global tico.FieldFn: type = @tc_FieldFn
global tico.FieldType: type = @tc_FieldType
global tico.Serialization: type = @tc_Serialization
global tico.Field: type = @tc_Field
global tico.Meta: type = @tc_Meta

-- export enums
global tico.FIELD_TYPE = TIC_FIELD_TYPE_
global tico.AUDIO_USAGE = TIC_AUDIO_USAGE_
global tico.DRAW_MODE = TIC_DRAW_MODE_
global tico.FRAGMENT_SHADERS = TIC_FRAGMENT_SHADERS_
global tico.VERTEX_SHADERS = TIC_VERTEX_SHADERS_
global tico.WindowFlags = TIC_WindowFlags_
global tico.KEY = TIC_KEY_
global tico.MOUSEBUTTON = TIC_MOUSEBUTTON_
global tico.JOYSTICKS = TIC_JOYSTICKS_
global tico.JOYSTICK_BUTTON = TIC_JOYSTICK_BUTTON_
global tico.JOYSTICK_AXES = TIC_JOYSTICK_AXES_
global tico.INPUT_FLAGS = TIC_INPUT_FLAGS_
global tico.SHADER_UNIFORM = TIC_SHADER_UNIFORM_
global tico.FILE_TYPE = TIC_FILE_TYPE_
global tico.WRITE_MODE = TIC_WRITE_MODE_

-- export constants
global tico.RESOURCE_ERROR = TIC_RESOURCE_ERROR
global tico.RESOURCE_LOADED = TIC_RESOURCE_LOADED
global tico.RESOURCE_MISSING_DEP = TIC_RESOURCE_MISSING_DEP
global tico.RESOURCE_CHANGED = TIC_RESOURCE_CHANGED

global tico.CURSOR_ARROW = TIC_CURSOR_ARROW
global tico.CURSOR_TEXT = TIC_CURSOR_TEXT
global tico.CURSOR_CROSSHAIR = TIC_CURSOR_CROSSHAIR
global tico.CURSOR_HAND = TIC_CURSOR_HAND
global tico.CURSOR_HRESIZE = TIC_CURSOR_HRESIZE
global tico.CURSOR_VRESIZE = TIC_CURSOR_VRESIZE

-- create color palette with the same values as the original ones
global tico.WHITE: tc_Color <const> = { 255, 255, 255, 255 }
global tico.BLACK: tc_Color <const> = {   0,   0,   0, 255 }
global tico.BLUE : tc_Color <const> = {  48,  52, 109, 255 }
global tico.RED  : tc_Color <const> = { 208,  70,  72, 255 }
global tico.GREEN: tc_Color <const> = {  52, 101,  36, 255 }
global tico.GRAY : tc_Color <const> = {  78,  74,  78, 255 }
global tico.BROWN: tc_Color <const> = { 133,  76,  48, 255 }
global tico.BG   : tc_Color <const> = {  75,  90,  90, 255 }

]=],

'\n-- apply operator overloading',

gen_math_op_overloading()

}, '\n')

nldecl.on_finish = function()
  local function gen_callback_gsub(varname, vartypename, vartype, nocomment)
    return varname..': '..vartypename, varname..': '..vartype..(nocomment and '' or ' --[['..vartypename..']]')
  end

  local binding_file = io.open('output/tico.nelua', 'w+')
  if not binding_file then
    error'could not open tico.nelua code'
  end

  local binding_content = ''

  do -- global substitutions
    binding_content = nldecl.emitter
      :generate()

  -- ================= --
  -- basic namespacing --
  -- ================= --

      :gsub('global function tico_(.-)%((.-)<cimport,', "function tico.%1(%2<cimport'tico_%1',")
      :gsub('global TIC_', 'local TIC_')
      :gsub('global tc_', 'local tc_')

  -- ==================== --
  -- simplify enum fields --
  -- ==================== --

      :gsub('  TIC_', '  ')

  -- ============== --
  -- type callbacks --
  -- ============== --

      :gsub(gen_callback_gsub('readFile', 'ReadFunction', 'function(*tc_Filesystem, cstring, *csize): *cuchar'))
      :gsub(gen_callback_gsub('writeFile', 'WriteFunction', 'function(*tc_Filesystem, cstring, cstring, csize, TIC_WRITE_MODE_): void'))
      :gsub(gen_callback_gsub('fileExists', 'FileExistsFunction', 'function(*tc_Filesystem, cstring): boolean'))

      :gsub(gen_callback_gsub('load', 'loadFromJson', 'function(*cJSON): *tc_Field'))
      :gsub(gen_callback_gsub('json', 'exportToJson', 'function(*cJSON): *tc_Field'))
      :gsub(gen_callback_gsub('draw', 'drawField', 'function(*tc_Field, tc_Vec2, float32): void'))
      :gsub(gen_callback_gsub('imgui', 'imguiField', 'function(): void'))

      :gsub(gen_callback_gsub('init', 'EditorPluginInit', 'function(pointer, *tc_EditorWindow): cint'))
      :gsub(gen_callback_gsub('create', 'EditorPluginUpdate', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('update', 'EditorPluginUpdate', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('draw', 'EditorPluginUpdate', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('draw_panel', 'EditorPluginUpdate', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('destroy', 'EditorPluginUpdate', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('save', 'EditorPluginUpdate', 'function(pointer): cint'))

      :gsub(gen_callback_gsub('enable', 'PluginEnable', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('disable', 'PluginDisable', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('load', 'PluginLoad', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('update', 'PluginUpdate', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('pre_draw', 'PluginPreDraw', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('draw', 'PluginDraw', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('post_draw', 'PluginPostDraw', 'function(pointer): cint'))
      :gsub(gen_callback_gsub('terminate', 'PluginTerminate', 'function(pointer): cint'))

      :gsub(gen_callback_gsub('loader', 'PluginResourceLoader', 'function(*tc_ResourceManager, *tc_Resource, *cJSON): tc_Resource'))
      :gsub(gen_callback_gsub('store', 'PluginResourceStore', 'function(*tc_ResourceManager, *tc_Resource): *cJSON'))

  -- ========================== --
  -- simplify unions as records --
  -- ========================== --

    -- these ones transforms this:
    -- ```lua
    -- local tc_Color: type <cimport, nodecl> = @record{
    --   __unnamed1: union{
    --     data: [4]cuchar,
    --     __unnamed1: record{
    --       r: cuchar,
    --       g: cuchar,
    --       b: cuchar,
    --       a: cuchar
    --     }
    --   }
    -- }
    -- ```
    -- to:
    -- ```lua
    -- local tc_Color: type <cimport, nodecl> = @record{
    --   r: cuchar,
    --   g: cuchar,
    --   b: cuchar,
    --   a: cuchar
    -- }
    -- ```
    -- this is just to make the library easier to use

      :gsub('%s.__unnamed1: union{%s.(.-)%s.}%s.', '%1')
      :gsub('%s.__unnamed1: record{%s.', '')
      :gsub('%s.__unnamed2: record{.-}', '')

      :gsub('%s.v: %[4%]tc_Vec4,%s.', '')

      :gsub('%s.data: %[%d+%]cint,%s.(.-)%s.}', '%1')
      :gsub('%s.data: %[%d+%]float32,%s.(.-)%s.}', '%1')
      :gsub('%s.data: %[%d+%]cuchar,%s.(.-)%s.}', '%1')

      :gsub('%s.data: %[%d+%]%[%d+%]float32,%s.(.-)%s.}', '%1')

    -- removing weird artifacts
      :gsub('        ', '  ')
      :gsub('       ', '  ')
      :gsub('      ', '  ')

      :gsub('\n  ,\n  \n}', '\n}')
      :gsub('\n \n}', '\n}')

    -- modify boolean returns
      :gsub('tico.window_should_close%(%): cint', 'tico.window_should_close(): boolean')
      :gsub('tico.window_should_close%(%): cint', 'tico.window_should_close(): boolean')

  -- ======================================= --
  -- convert cint returns to boolean returns --
  -- ======================================= --

      -- TODO: Add boolean returns only where makes sense
      -- tico.audio_init(): cint
      -- tico.audio_start_device(): cint
      -- tico.audio_stop_device(): cint
      -- tico.plugin_is_active(name: cstring): cint
      -- tico.imgui_init(window: *tc_Window): cint
      -- tico.imgui_Begin(name: cstring, open: *cint, flags: ImGuiWindowFlags_): cint
      -- tico.utils_hash(key: cstring): cint
      -- tico.utf8_decode(p: *cuchar): cint
      -- tico.sign(a: float32): cint
      -- tico.filesystem_init(fs: *tc_Filesystem): cint
      -- tico.json_is_valid(filename: cstring): cint
      -- tico.json_add_item(json: *cJSON, name: cstring, item: *cJSON): cint
      -- tico.json_is_string(json: *cJSON): cint
      -- tico.json_is_number(json: *cJSON): cint
      -- tico.json_is_boolean(json: *cJSON): cint
      -- tico.json_to_boolean(json: *cJSON): cint
      -- tico.json_opt_boolean(json: *cJSON, opt: cint): cint
      -- tico.json_get_boolean(json: *cJSON, name: cstring, index: cint): cint
      -- tico.json_get_opt_boolean(json: *cJSON, name: cstring, index: cint, opt: cint): cint
      -- tico.json_is_vec2(json: *cJSON): cint
      -- tico.json_is_vec3(json: *cJSON): cint
      -- tico.json_is_vec4(json: *cJSON): cint
      -- tico.json_is_array(json: *cJSON): cint
      -- tico.json_is_int_array(json: *cJSON): cint
      -- tico.json_is_object(json: *cJSON): cint
      -- tico.json_get_array_size(json: *cJSON): cint
      -- tico.field_length(field: *tc_Field): cint
      -- tico.field_get_boolean(field: *tc_Field, name: cstring): cint
      -- tico.field_get_opt_boolean(field: *tc_Field, name: cstring, opt: cint): cint
      -- tico.field_to_boolean(field: *tc_Field): cint
      -- tico.field_to_opt_boolean(field: *tc_Field, value: cint): cint
      -- tico.tileset_from_json(tileset: *tc_Tileset, json: *cJSON): cint
      -- tico.tileset_calc_mask(tileset: tc_Tileset, bitmask_array: *cint): cint
      -- tico.tileset_get_from_bitmask(tileset: tc_Tileset, bitmask: cint): cint
      -- tico.tilemap_from_json(tilemap: *tc_Tilemap, json: *cJSON): cint
      -- tico.tilemap_has_tile(map: tc_Tilemap, x: cint, y: cint): cint
      -- tico.tilemap_autotile(tilemap: tc_Tilemap, index: cint): cint
      -- tico.tilemap_autotile_pos(tilemap: tc_Tilemap, x: cint, y: cint): cint
      -- tico.tilemap_get_index(map: tc_Tilemap, x: cint, y: cint): cint
      -- tico.sprite_from_json(sprite: *tc_Sprite, json: *cJSON): cint
      -- tico.timer_init(timer: *tc_Timer): cint
      -- tico.plugin_destroy(plugin: *tc_Plugin): cint
      -- tico.plugin_lua_load(lua: *tc_Lua): cint
      -- tico.plugin_lua_update(lua: *tc_Lua): cint
      -- tico.plugin_lua_draw(lua: *tc_Lua): cint
      -- tico.resource_change_lua(resource: *tc_Resource): cint
      -- tico.plugin_resources_init(manager: *tc_ResourceManager): cint
      -- tico.plugin_resources_default_loaders(manager: *tc_ResourceManager): cint
      -- tico.plugin_resources_load(manager: *tc_ResourceManager, type: cstring, name: cstring, path: cstring): cint
      -- tico.plugin_resources_destroy(manager: *tc_ResourceManager): cint
      -- tico.plugin_resources_check_json_deps(manager: *tc_ResourceManager, json: *cJSON): cint
      -- tico.plugin_resources_add(manager: *tc_ResourceManager, type: cstring, name: cstring, resource: *tc_Resource): cint
      -- tico.plugin_resources_store(resource: *tc_Resource): cint
      -- tico.widget_panel_begin(widget: *tc_PanelWidget): cint
      -- tico.widget_grid_update(widget: *tc_GridWidget, panel: *tc_PanelWidget): cint
      -- tico.widget_grid_draw(widget: *tc_GridWidget, panel: *tc_PanelWidget): cint
      -- tico.object_is_hovered(object: *tc_Object, origin: tc_Vec2, scale: float32): cint
      -- tico.widget_object_init(widget: *tc_ObjectWidget, data: *tc_Field): cint
      -- tico.widget_object_update(widget: *tc_ObjectWidget, panel: *tc_PanelWidget): cint
      -- tico.widget_object_draw(widget: *tc_ObjectWidget, panel: *tc_PanelWidget, active: *cint): cint
      -- tico.widget_object_edit(widget: *tc_ObjectWidget, object: *tc_Object): cint
      -- tico.widget_object_selected(widget: *tc_ObjectWidget, object: *tc_Object, origin: tc_Vec2, scale: float32): cint
      -- tico.widget_object_resized(widget: *tc_ObjectWidget, object: *tc_Object): cint
      -- tico.plugin_editor_load(editor: *tc_Editor): cint
      -- tico.plugin_editor_update(editor: *tc_Editor): cint
      -- tico.plugin_editor_draw(editor: *tc_Editor): cint
      -- tico.plugin_editor_add_plugin(editor: *tc_Editor, type: cstring, plugin: *tc_EditorPlugin): cint
      -- tico.plugin_editor_open(uuid: cstring): cint
      -- tico.editor_draw_window(window: *tc_EditorWindow): cint
      -- tico.audio_get_id(buffer: *tc_AudioBuffer): cint
      -- tico.buffer_is_playing(audioBuffer: *tc_AudioBuffer): cint
      -- tico.buffer_is_paused(audioBuffer: *tc_AudioBuffer): cint
      -- tico.sound_is_playing(sound: tc_Sound): cint
      -- tico.sound_is_paused(sound: tc_Sound): cint
      -- tico.render_init(render: *tc_Render): cint
      -- tico.render_is_empty(render: *tc_Render): cint
      -- tico.render_is_full(render: *tc_Render, vertices: cint): cint
      -- tico.batch_is_empty(batch: tc_Batch): cint
      -- tico.batch_is_full(batch: tc_Batch, vertices: cint): cint
      -- tico.graphics_init(graphics: *tc_Graphics): cint
      -- tico.texture_get_width(texture: tc_Texture): cint
      -- tico.texture_get_height(texture: tc_Texture): cint
      -- tico.image_get_width(image: tc_Image): cint
      -- tico.image_get_height(image: tc_Image): cint
      -- tico.canvas_get_width(canvas: tc_Canvas): cint
      -- tico.canvas_get_height(canvas: tc_Canvas): cint
      -- tico.shader_compile(source: cstring, shaderType: cint): cint
      -- tico.shader_load_program(vertexShader: cint, fragShader: cint): cint
      -- tico.font_get_text_width(font: tc_Font, text: cstring, len: cint): cint
      -- tico.font_get_text_height(font: tc_Font, text: cstring, len: cint): cint
      -- tico.window_init(window: *tc_Window, title: cstring, width: cint, height: cint, flags: TIC_WindowFlags_): cint
      -- tico.window_deinit(window: *tc_Window): cint
      -- tico.input_init(input: *tc_Input, flags: TIC_INPUT_FLAGS_): cint
      -- tico.input_update(input: *tc_Input): cint
      -- tico.init(config: *tc_Config): cint
      -- tico.plugins_is_active(name: cstring): cint
      -- tico.filesystem_internal_file_exists(filename: cstring): cint
      -- tico.filesystem_external_file_exists(filename: cstring): cint
      -- tico.filesystem_file_exists(filename: cstring): cint
      -- tico.input_get_key_code(name: cstring): cint
      -- tico.input_get_joy_btncode(name: cstring): cint
      -- tico.input_get_joy_axiscode(name: cstring): cint
      -- tico.input_get_mouse_code(name: cstring): cint
      :gsub('(.-_is_.-%(.-%): )cint(.-end)', '%1boolean%2')

      :gsub('(_down%(.-%): )cint(.-end)', '%1boolean%2')
      :gsub('(_pressed%(.-%): )cint(.-end)', '%1boolean%2')
      :gsub('(_up%(.-%): )cint(.-end)', '%1boolean%2')
      :gsub('(_released%(.-%): )cint(.-end)', '%1boolean%2')

      :gsub('(_equals%(.-%): )cint(.-end)', '%1boolean%2')
  end

  --print(binding_content)

  binding_file:write(binding_content)
  binding_file:close()
end
