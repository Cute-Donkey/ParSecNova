using Godot;

namespace ParSecNova.Core
{
    public partial class SimpleTestControls : Node3D
    {
        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
            GD.Print("SimpleTestControls: C# script loaded successfully!");
            
            // Position camera for cockpit view
            var camera = GetNode<Camera3D>("Ship/Camera3D");
            var asteroid = GetNode<RigidBody3D>("Asteroid");
            
            if (camera != null && asteroid != null)
            {
                // Position asteroid in front of camera
                var cameraPosition = camera.GlobalPosition;
                var cameraForward = -camera.GlobalTransform.Basis.Z;
                var distance = 75.0f;
                asteroid.GlobalPosition = cameraPosition + cameraForward * distance;
                
                GD.Print("SimpleTestControls: Scene positioned successfully!");
            }
        }
        
        public override void _Process(double delta)
        {
            // Simple exit on ESC
            if (Input.IsKeyPressed(Key.Escape))
            {
                GetTree().Quit();
            }
        }
    }
}
