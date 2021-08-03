# Twisted Decal for Godot 3

This repository contains my shader-based solution for making decals in Godot 3.0. This shader is only for Godot 3 and has been tested with Godot 3.2. The reason behind the creation of this shader is to try and get a workable, flexable, and relatively fast solution for decals in Godot 3+.

The biggest reason for this is just for learning purposes, so the code and solution may not be the most optimial. While I will likely continue to refine and improve this decal shader/method over time, **I am not actively supporting this code**, so please keep that in mind if you plan on using it. Thanks!

You can also find a more lightweight decal shader I made here on [GodotShaders](https://godotshaders.com/shader/decal-example/). It's missing a few features, but its also a bit more performance friendly.

Hopefully this repository can help anyone looking to make decals in Godot 3! Godot 4.0 has a built-in decal system, so if you need stable, quick decals in your Godot projects you may want to look at using Godot 4.0 when it's released.

### Features:

* The decal can overlay itself over the environment and wrap around objects
* The decal can correctly only project on triangles facing in the correct direction
  * Note: Requires passing a world normal texture through a seperate viewport
  * While this does increase the rendering cost slightly, you also get the benefit of being able to choose what the decal can draw on by what you include in the seperate viewport with no additional rendering cost!
  * The example project has this additional viewport setup, along with a simple material to render the normals of each object. The shader is a little heavier than it may need to be for static objects, but with the way it is written, it will even work with animated meshes!
* The decal can selectively draw only on given objects (see subpoint in point above)
* The decal supports lighting by reconstructing normals using the depth buffer for semi-accurate lighting
* The decal supports normal maps
  * It can easily be extended to include emission, roughness, metalness, etc.
* Shader is written in clearly labeled sections for easy reading and adjusting
* This repository includes an example project that can be used as reference for how to use the shader! All of the assets included are original, created specifically for this repository, and are also licensed under MIT.
  * Please note that I am not a 2D artst, so the included example decals are a little rough. Hopefully they still help showcase how the decal system works though!

### Credits:

Thanks to the following:

* [Ronja's Tutorials: Unlit Dynamic Decals/Projections](https://www.ronja-tutorials.com/post/054-unlit-dynamic-decals/) - initial inspiration that got my interest in making a decal solution for Godot using shaders.
  * Additionally: The [tutorial on post-processing the normal texture](https://www.ronja-tutorials.com/post/018-postprocessing-normal/) was also *extremely* helpful for getting the world-normals out of a seperate Viewport.
* [Andon M. Coleman on Stackoverflow](https://stackoverflow.com/questions/32227283/getting-world-position-from-depth-buffer-value) - helpful code snippet for reconstructing world position from the depth texture.
* [Wicked Engine](https://wickedengine.net/2019/09/22/improved-normal-reconstruction-from-depth/) - helpful code for reconstructing normal from depth. I only used the simple example and it was a really insightful article.
* [user464230 on Stackoverflow](https://stackoverflow.com/questions/5255806/how-to-calculate-tangent-and-binormal) - helpful code snippet on calculating Tangent and Binormal from Normal.
* The Godot developers, contributors, and the community for helping make Godot awesome!

#### possible improvements list

* Add pictures to README file
* Optimize depth normal reconstruction code for better performance
  * It may be possible to reuse some of the work done for calculating the world position from the depth texture for reconstructing the normals.
* Test shader in GLES2 (see if it's possible to get it working without too many alterations)
* Improve code setup and ease-of-use for integrating into projects
  * Potentially shader materials can be automatically gotten using groups. Same for copying the environment to the normal Viewport.
