#version 300 es

#define MAX_LIGHTS 16

// Fragment shaders don't have a default precision so we need
// to pick one. mediump is a good default. It means "medium precision".
precision mediump float;

// struct definitions
struct AmbientLight {
    vec3 color;
    float intensity;
};

struct DirectionalLight {
    vec3 direction;
    vec3 color;
    float intensity;
};

struct PointLight {
    vec3 position;
    vec3 color;
    float intensity;
};

struct Material {
    vec3 kA;
    vec3 kD;
    vec3 kS;
    float shininess;
};

// lights and materials
uniform AmbientLight u_lights_ambient[MAX_LIGHTS];
uniform DirectionalLight u_lights_directional[MAX_LIGHTS];
uniform PointLight u_lights_point[MAX_LIGHTS];

uniform Material u_material;

// camera position
uniform vec3 u_eye;

// received from vertex stage
// TODO: Create any needed `in` variables here
// TODO: These variables correspond to the `out` variables from the vertex stage
in vec3 position;
in vec3 normal;

// with webgl 2, we now have to define an out that will be the color of the fragment
out vec4 o_fragColor;

// Shades an ambient light and returns this light's contribution
vec3 shadeAmbientLight(Material material, AmbientLight light) {

    // TODO: Implement this method
    return light.color * light.intensity * material.kA;
}

// Shades a directional light and returns its contribution
vec3 shadeDirectionalLight(Material material, DirectionalLight light, vec3 normal, vec3 eye, vec3 vertex_position) {

    // TODO: Implement this method
    float diffuse = max(dot(normal, light.direction), 0.0);

    vec3 viewDir = normalize(eye - vertex_position);

    vec3 h = normalize(light.direction + viewDir);

    float specular = pow(max(dot(h, normal), 0.0), material.shininess);

    return vec3(diffuse * material.kD * light.intensity * light.color + specular * material.kS);
}

// Shades a point light and returns its contribution
vec3 shadePointLight(Material material, PointLight light, vec3 normal, vec3 eye, vec3 vertex_position) {

    // TODO: Implement this method
    vec3 lightDir = normalize(light.position - vertex_position);

    float diffuse = max(dot(normal, lightDir), 0.0);

    vec3 viewDir = normalize(eye - vertex_position);

    vec3 h = normalize(lightDir + viewDir);

    float specular = pow(max(dot(h, normal), 0.0), material.shininess);

    return vec3(diffuse * material.kD * light.intensity * light.color + specular * material.kS);
}


void main() {

    // TODO: PHONG SHADING
    // TODO: Implement the fragment stage
    // TODO: Use the above methods to shade every light in the light arrays
    // TODO: Accumulate their contribution and use this total light contribution to pass to o_fragColor
    vec3 ambientLight = vec3(0.0);
    vec3 pointLight = vec3(0.0);
    vec3 directionalLight = vec3(0.0);
    
    for (int i = 0; i < 1; i++)
    {
        ambientLight += shadeAmbientLight(u_material, u_lights_ambient[i]);
        directionalLight += shadeDirectionalLight(u_material,u_lights_directional[i],normal,u_eye,position);
    }

    for (int i = 0; i < 2; i++)
    {
        pointLight += shadePointLight(u_material, u_lights_point[i], normal, u_eye, position);
    }

    vec3 color = ambientLight + pointLight * 0.5 + directionalLight;
    // TODO: Pass the shaded vertex color to the output
    o_fragColor = vec4(color, 1.0);
}
