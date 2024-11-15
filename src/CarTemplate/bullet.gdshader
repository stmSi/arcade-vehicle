shader_type spatial;
render_mode unshaded;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	    ALBEDO = vec3(1.0, 0.8, 0.0);  // Orange color
    EMISSION = ALBEDO * 2.0;       // Make it glow
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
