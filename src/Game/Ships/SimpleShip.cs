using Godot;

namespace ParSecNova.Game.Ships
{
    public partial class SimpleShip : RigidBody3D
    {
        [Export]
        public float MaxThrust { get; set; } = 1000.0f;
        
        [Export]
        public float MaxTorque { get; set; } = 500.0f;

        private Vector3 _thrustForce = Vector3.Zero;
        private Vector3 _torqueForce = Vector3.Zero;

        public override void _Ready()
        {
            // Disable gravity for space physics
            GravityScale = 0.0f;
            LinearDamp = 0.01f;
            AngularDamp = 0.01f;
            
            GD.Print("SimpleShip initialized!");
        }

        public override void _PhysicsProcess(double delta)
        {
            // Handle input
            var inputVector = Vector3.Zero;
            var torqueVector = Vector3.Zero;
            
            // Thrust controls
            if (Input.IsActionPressed("thrust_forward"))
                inputVector += -Transform.Basis.Z;
            if (Input.IsActionPressed("thrust_backward"))
                inputVector += Transform.Basis.Z;
            
            // Rotation controls
            if (Input.IsActionPressed("pitch_up"))
                torqueVector += Transform.Basis.X;
            if (Input.IsActionPressed("pitch_down"))
                torqueVector += -Transform.Basis.X;
            if (Input.IsActionPressed("roll_left"))
                torqueVector += -Transform.Basis.Z;
            if (Input.IsActionPressed("roll_right"))
                torqueVector += Transform.Basis.Z;
            if (Input.IsActionPressed("yaw_left"))
                torqueVector += Transform.Basis.Y;
            if (Input.IsActionPressed("yaw_right"))
                torqueVector += -Transform.Basis.Y;
            
            // Apply forces
            if (inputVector != Vector3.Zero)
                ApplyCentralForce(inputVector.Normalized() * MaxThrust);
            
            if (torqueVector != Vector3.Zero)
                ApplyTorque(torqueVector.Normalized() * MaxTorque);
            
            // Apply persistent forces
            if (_thrustForce != Vector3.Zero)
                ApplyCentralForce(_thrustForce);
            
            if (_torqueForce != Vector3.Zero)
                ApplyTorque(_torqueForce);
        }

        public void ApplyThrust(Vector3 direction, float thrustAmount)
        {
            _thrustForce = direction.Normalized() * thrustAmount * MaxThrust;
        }

        public void ApplyCustomTorque(Vector3 direction, float torqueAmount)
        {
            _torqueForce = direction.Normalized() * torqueAmount * MaxTorque;
        }

        public void StopThrust()
        {
            _thrustForce = Vector3.Zero;
        }

        public void StopTorque()
        {
            _torqueForce = Vector3.Zero;
        }
    }
}
