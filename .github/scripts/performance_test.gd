extends SceneTree

func _init():
    print("⚛️ Physics performance test starting...")
    
    # Create a scene root and set it as current scene
    var root = Node3D.new()
    current_scene = root
    
    # Create multiple objects to test physics performance
    var objects = []
    var object_count = 50
    
    for i in range(object_count):
        var body = RigidBody3D.new()
        body.mass = 100.0
        body.gravity_scale = 0.0
        body.position = Vector3(randf_range(-20, 20), randf_range(-20, 20), randf_range(-20, 20))
        
        var shape = CollisionShape3D.new()
        var sphere = SphereShape3D.new()
        sphere.radius = 1.0
        shape.shape = sphere
        body.add_child(shape)
        
        root.add_child(body)
        objects.append(body)
    
    print("✅ Created ", object_count, " physics objects")
    
    # Run physics simulation for 2 seconds
    await create_timer(2.0).timeout
    
    # Check performance
    var fps = Engine.get_frames_per_second()
    print("📊 FPS: ", fps)
    
    if fps < 30:
        print("⚠️ Low FPS detected: ", fps)
    elif fps >= 60:
        print("✅ Good FPS: ", fps)
    else:
        print("📈 Acceptable FPS: ", fps)
    
    # Cleanup
    for obj in objects:
        obj.queue_free()
    
    print("✅ Physics performance test completed")
    quit(0)
