



local function gen_callback_gsub(varname, vartypename, vartype, nocomment)
  return varname..': '..vartypename, varname..': '..vartype..(nocomment and '' or ' --[['..vartypename..']]')
end


local result = {}

local raw_tico_file = io.open'output/raw_tico.nelua'
local tico_file = io.open('output/tico.nelua', 'w+')
if not raw_tico_file then
  error'could not open raw_tico.nelua code'
end

if not tico_file then
  error'could not open tico.nelua code'
end

local raw_tico_content = raw_tico_file:read('a')


do -- global substitutions
  raw_tico_content = raw_tico_content:gsub('global function tico_(.-)%((.-)<cimport,', "function tico.%1(%2<cimport'tico_%1',")

  raw_tico_content = raw_tico_content:gsub('global tc_', 'local tc_')

  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('readFile', 'ReadFunction', 'function(*tc_Filesystem, cstring, *csize): *cuchar'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('writeFile', 'WriteFunction', 'function(*tc_Filesystem, cstring, cstring, csize, TIC_WRITE_MODE_): void'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('fileExists', 'FileExistsFunction', 'function(*tc_Filesystem, cstring): boolean'))

  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('load', 'loadFromJson', 'function(*cJSON): *tc_Field'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('json', 'exportToJson', 'function(*cJSON): *tc_Field'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('draw', 'drawField', 'function(*tc_Field, tc_Vec2, float32): void'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('imgui', 'imguiField', 'function(): void'))

  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('init', 'EditorPluginInit', 'function(pointer, *tc_EditorWindow): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('create', 'EditorPluginUpdate', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('update', 'EditorPluginUpdate', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('draw', 'EditorPluginUpdate', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('draw_panel', 'EditorPluginUpdate', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('destroy', 'EditorPluginUpdate', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('save', 'EditorPluginUpdate', 'function(pointer): cint'))

  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('enable', 'PluginEnable', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('disable', 'PluginDisable', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('load', 'PluginLoad', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('update', 'PluginUpdate', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('pre_draw', 'PluginPreDraw', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('draw', 'PluginDraw', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('post_draw', 'PluginPostDraw', 'function(pointer): cint'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('terminate', 'PluginTerminate', 'function(pointer): cint'))

  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('loader', 'PluginResourceLoader', 'function(*tc_ResourceManager, *tc_Resource, *cJSON): tc_Resource'))
  raw_tico_content = raw_tico_content:gsub(gen_callback_gsub('store', 'PluginResourceStore', 'function(*tc_ResourceManager, *tc_Resource): *cJSON'))

  do
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
    --       r: cuchar,
    --       g: cuchar,
    --       b: cuchar,
    --       a: cuchar
    -- }
    -- ```
    -- this is just to make the library easier to use

    raw_tico_content = raw_tico_content:gsub('%s.__unnamed1: union{%s.(.-)%s.}%s.', '%1')
    raw_tico_content = raw_tico_content:gsub('%s.__unnamed1: record{%s.', '')
    raw_tico_content = raw_tico_content:gsub('%s.__unnamed2: record{.-}', '')

    raw_tico_content = raw_tico_content:gsub('%s.v: %[4%]tc_Vec4,%s.', '')

    raw_tico_content = raw_tico_content:gsub('%s.data: %[%d+%]cint,%s.(.-)%s.}', '%1')
    raw_tico_content = raw_tico_content:gsub('%s.data: %[%d+%]float32,%s.(.-)%s.}', '%1')
    raw_tico_content = raw_tico_content:gsub('%s.data: %[%d+%]cuchar,%s.(.-)%s.}', '%1')

    raw_tico_content = raw_tico_content:gsub('%s.data: %[%d+%]%[%d+%]float32,%s.(.-)%s.}', '%1')

    raw_tico_content = raw_tico_content:gsub('        ', '  ')
    raw_tico_content = raw_tico_content:gsub('       ', '  ')
    raw_tico_content = raw_tico_content:gsub('      ', '  ')

    raw_tico_content = raw_tico_content:gsub('\n  ,\n  \n}', '\n}')
    raw_tico_content = raw_tico_content:gsub('\n \n}', '\n}')
  end

  -- modify boolean returns
  raw_tico_content = raw_tico_content:gsub('tico.window_should_close%(%): cint', 'tico.window_should_close(): boolean')
end

tico_file:write(raw_tico_content)
