using Godot;

namespace ParSecNova.Game.Environment
{
    public partial class SimpleAsteroid : RigidBody3D
    {
        [Export]
        public float Health { get; set; } = 100.0f;

        public override void _Ready()
        {
            // Set up physics properties
            GravityScale = 0.0f;
            LinearDamp = 0.01f;
            AngularDamp = 0.01f;
            
            // Add some random rotation for visual effect
            AngularVelocity = new Vector3(
                (float)GD.RandRange(-1.0, 1.0),
                (float)GD.RandRange(-1.0, 1.0),
                (float)GD.RandRange(-1.0, 1.0)
            );
            
            GD.Print("SimpleAsteroid initialized!");
        }

        public void TakeDamage(float damage)
        {
            Health -= damage;
            GD.Print($"Asteroid took {damage} damage. Health: {Health}");
            
            if (Health <= 0)
            {
                DestroyAsteroid();
            }
        }

        private void DestroyAsteroid()
        {
            GD.Print("Asteroid destroyed!");
            
            // Create simple explosion effect
            var light = new OmniLight3D();
            light.LightColor = Colors.Orange;
            light.LightEnergy = 8.0f;
            light.ShadowEnabled = false;
            light.Position = GlobalPosition;
            
            GetTree().Root.AddChild(light);
            
            // Remove light after explosion
            var timer = GetTree().CreateTimer(1.0f);
            timer.Timeout += () => light.QueueFree();
            
            // Remove asteroid
            QueueFree();
        }
    }
}
