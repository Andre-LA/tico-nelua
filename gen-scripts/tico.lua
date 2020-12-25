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

nldecl.append_code = [=[
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

global tico.WHITE: tc_Color = { 255, 255, 255, 255 }
global tico.BLACK: tc_Color = {   0,   0,   0, 255 }
global tico.BLUE : tc_Color = {  48,  52, 109, 255 }
global tico.RED  : tc_Color = { 208,  70,  72, 255 }
global tico.GREEN: tc_Color = {  52, 101,  36, 255 }
global tico.GRAY : tc_Color = {  78,  74,  78, 255 }
global tico.BROWN: tc_Color = { 133,  76,  48, 255 }
global tico.BG   : tc_Color = {  75,  90,  90, 255 }
]=]

nldecl.on_finish = function()
  local function gen_callback_gsub(varname, vartypename, vartype, nocomment)
    return varname..': '..vartypename, varname..': '..vartype..(nocomment and '' or ' --[['..vartypename..']]')
  end

  local binding_file = io.open('../output/tico.nelua', 'w+')
  if not binding_file then
    error'could not open tico.nelua code'
  end

  local binding_content = nldecl.emitter:generate()

  do -- global substitutions
    binding_content =
      binding_content:gsub('global function tico_(.-)%((.-)<cimport,', "function tico.%1(%2<cimport'tico_%1',")
                     :gsub('global tc_', 'local tc_')

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
  end

  binding_file:write(binding_content)
  binding_file:close()
end
