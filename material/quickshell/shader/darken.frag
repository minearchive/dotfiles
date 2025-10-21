uniform sampler2D source;
varying highp vec2 qt_TexCoord0;
uniform lowp float darkness;

void main() {
    vec4 color = texture2D(source, qt_TexCoord0);
    color.rgb *= darkness;
    gl_FragColor = color;
}
