#version 300 es

#define MAX_LIGHTS 16

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


// an attribute will receive data from a buffer
in vec3 a_position;
in vec3 a_normal;

// camera position
uniform vec3 u_eye;

// transformation matrices
uniform mat4x4 u_m;
uniform mat4x4 u_v;
uniform mat4x4 u_p;

// lights and materials
uniform AmbientLight u_lights_ambient[MAX_LIGHTS];
uniform DirectionalLight u_lights_directional[MAX_LIGHTS];
uniform PointLight u_lights_point[MAX_LIGHTS];

uniform Material u_material;

// shading output
out vec4 o_color;

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

    // TODO: GORAUD SHADING
    // TODO: Implement the vertex stage
    // TODO: Transform positions and normals
    // NOTE: Normals are transformed differently from positions. Check the book and resources.
    // TODO: Use the above methods to shade every light in the light arrays
    // TODO: Accumulate their contribution and use this total light contribution to pass to o_color
    gl_Position = u_p * u_v * u_m * vec4(a_position, 1.0);

    vec3 position = (u_m * vec4(a_position, 1.0)).xyz;
    vec3 normal = (u_m * vec4(a_normal, 0.0)).xyz;
    
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
    

    // TODO: Pass the shaded vertex color to the fragment stage
    vec3 color = ambientLight + pointLight * 0.5 + directionalLight;
    // vec3 color = ambientLight + directionalLight;
    o_color = vec4(color, 1.0);
}