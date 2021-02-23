obs = obslua
bit = require('bit')

SETTING_ALPHA_THRESHOLD = 'alpha_threshold'
SETTING_LINE_COLOR = 'line_color'
SETTING_LINE_ALPHA = 'line_alpha'
SETTING_LINE_WIDTH = 'line_width'

TEXT_ALPHA_THRESHOLD = '透明度閾値'
TEXT_LINE_COLOR = '線の色'
TEXT_LINE_ALPHA = '線の不透明度'
TEXT_LINE_WIDTH = '線の幅'

SHADER = [[
uniform float4x4 ViewProj;
uniform texture2d image;

uniform float2 pixel_size;
uniform float alpha_threshold;
uniform float4 line_color;
uniform float line_width;

sampler_state textureSampler {
    Filter    = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

struct VertDataIn {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

struct VertDataOut {
    float4 pos : POSITION;
    float2 uv  : TEXCOORD0;
};

VertDataOut VShader(VertDataIn v_in)
{
    VertDataOut vert_out;
    vert_out.pos = mul(float4(v_in.pos.xyz, 1.0), ViewProj);
    vert_out.uv  = v_in.uv;
    return vert_out;
}

float diff(float2 uv, float2 diff)
{
    float4 col1 = image.Sample(textureSampler, uv - diff);
    float4 col2 = image.Sample(textureSampler, uv + diff);

    return col2.a - col1.a;
}

float4 mixColor(float4 src, float4 dst)
{
    return dst * (1.0 - src.a) + float4(src.rgb * src.a, src.a);
}

float4 PShader(VertDataOut v_in) : TARGET
{
    float w = pixel_size.x * line_width / 2;
    float h = pixel_size.y * line_width / 2;

    float d1 = diff(v_in.uv, float2(w, 0));
    float d2 = diff(v_in.uv, float2(0, h));
    float d3 = diff(v_in.uv, float2(w * 0.71, h * 0.71));
    float d4 = diff(v_in.uv, float2(w * 0.71, -h * 0.71));

    float4 color = image.Sample(textureSampler, v_in.uv);

    return (abs(d1) > alpha_threshold
      || abs(d2) > alpha_threshold
      || abs(d3) > alpha_threshold
      || abs(d4) > alpha_threshold)
      ? mixColor(line_color, color)
      : color;
}

technique Draw
{
    pass
    {
        vertex_shader = VShader(v_in);
        pixel_shader  = PShader(v_in);
    }
}
]]

source_def = {}
source_def.id = 'draw-outline'
source_def.type = obs.OBS_SOURCE_TYPE_FILTER
source_def.output_flags = bit.bor(obs.OBS_SOURCE_VIDEO)

function set_render_size(filter)
    target = obs.obs_filter_get_target(filter.context)

    local width, height
    if target == nil then
        width = 0
        height = 0
    else
        width = obs.obs_source_get_base_width(target)
        height = obs.obs_source_get_base_height(target)
    end

    filter.width = width
    filter.height = height
    width = width == 0 and 1 or width
    height = height == 0 and 1 or height
    filter.pixel_size.x = 1.0 / width
    filter.pixel_size.y = 1.0 / height
end

source_def.get_name = function()
    return '縁取り'
end

source_def.create = function(settings, source)
    filter = {}
    filter.params = {}
    filter.context = source
    filter.pixel_size = obs.vec2()
    filter.line_color = obs.vec4()

    set_render_size(filter)

    obs.obs_enter_graphics()
    filter.effect = obs.gs_effect_create(SHADER, nil, nil)
    if filter.effect ~= nil then
        filter.params.pixel_size = obs.gs_effect_get_param_by_name(filter.effect, 'pixel_size')
        filter.params.alpha_threshold = obs.gs_effect_get_param_by_name(filter.effect, 'alpha_threshold')
        filter.params.line_color = obs.gs_effect_get_param_by_name(filter.effect, 'line_color')
        filter.params.line_alpha = obs.gs_effect_get_param_by_name(filter.effect, 'line_alpha')
        filter.params.line_width = obs.gs_effect_get_param_by_name(filter.effect, 'line_width')
    end
    obs.obs_leave_graphics()
    
    if filter.effect == nil then
        source_def.destroy(filter)
        return nil
    end

    source_def.update(filter, settings)
    return filter
end

source_def.destroy = function(filter)
    if filter.effect ~= nil then
        obs.obs_enter_graphics()
        obs.gs_effect_destroy(filter.effect)
        obs.obs_leave_graphics()
    end
end

source_def.get_width = function(filter)
    return filter.width
end

source_def.get_height = function(filter)
    return filter.height
end

source_def.update = function(filter, settings)
    filter.alpha_threshold = obs.obs_data_get_double(settings, SETTING_ALPHA_THRESHOLD)

    line_color = obs.obs_data_get_int(settings, SETTING_LINE_COLOR)
    line_alpha = math.floor(obs.obs_data_get_double(settings, SETTING_LINE_ALPHA) * 255)
    obs.vec4_from_rgba(filter.line_color, line_color + line_alpha * 0x1000000)

    filter.line_width = obs.obs_data_get_double(settings, SETTING_LINE_WIDTH)

    set_render_size(filter)
end

source_def.video_render = function(filter, effect)
    obs.obs_source_process_filter_begin(filter.context, obs.GS_RGBA, obs.OBS_NO_DIRECT_RENDERING)

    obs.gs_effect_set_vec2(filter.params.pixel_size, filter.pixel_size)
    obs.gs_effect_set_float(filter.params.alpha_threshold, filter.alpha_threshold)
    obs.gs_effect_set_vec4(filter.params.line_color, filter.line_color)
    obs.gs_effect_set_float(filter.params.line_width, filter.line_width)

    obs.obs_source_process_filter_end(filter.context, filter.effect, filter.width, filter.height)
end

function script_description()
  return '縁取りフィルタ。透明な箇所と不透明な箇所の境目に線を描く'
end

source_def.get_properties = function(settings)
    props = obs.obs_properties_create()

    obs.obs_properties_add_float_slider(props, SETTING_ALPHA_THRESHOLD, TEXT_ALPHA_THRESHOLD, 0, 1, 0.01)
    obs.obs_properties_add_color(props, SETTING_LINE_COLOR, TEXT_LINE_COLOR)
    obs.obs_properties_add_float_slider(props, SETTING_LINE_ALPHA, TEXT_LINE_ALPHA, 0, 1, 0.01)
    obs.obs_properties_add_float_slider(props, SETTING_LINE_WIDTH, TEXT_LINE_WIDTH, 0, 100, 0.1)

    return props
end

source_def.get_defaults = function(settings)
    obs.obs_data_set_default_double(settings, SETTING_ALPHA_THRESHOLD, 0.99)
    obs.obs_data_set_default_int(settings, SETTING_LINE_COLOR, 0x000000)
    obs.obs_data_set_default_double(settings, SETTING_LINE_ALPHA, 1)
    obs.obs_data_set_default_double(settings, SETTING_LINE_WIDTH, 1)
end

source_def.video_tick = function(filter, seconds)
    set_render_size(filter)
end

obs.obs_register_source(source_def)
