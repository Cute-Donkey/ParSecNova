using Godot;
using ParSecNova.Core.Physics;
using ParSecNova.Game.Weapons;

namespace ParSecNova.Game.Ships
{
    /// <summary>
    /// Player ship controller with 6DoF movement and weapon systems.
    /// Handles input processing and ship physics.
    /// </summary>
    public partial class ShipController : NewtonianBody
    {
        /// <summary>
        /// Speed of ship rotation in radians per second.
        /// </summary>
        [Export] public float RotationSpeed { get; set; } = 2.0f;
        
        /// <summary>
        /// Power multiplier for thrust force.
        /// </summary>
        [Export] public float ThrustPower { get; set; } = 1.0f;
        
        /// <summary>
        /// Scene template for laser projectiles.
        /// </summary>
        [Export] public PackedScene LaserScene { get; set; }
        
        private Camera3D _camera;
        private LaserWeapon _laserWeapon;
        
        /// <summary>
        /// Called when the node enters the scene tree.
        /// Initializes camera and weapon systems.
        /// </summary>
        public override void _Ready()
        {
            base._Ready();
            _camera = GetNode<Camera3D>("Camera3D");
            
            // Create laser weapon
            _laserWeapon = new LaserWeapon();
            _laserWeapon.LaserScene = LaserScene;
            AddChild(_laserWeapon);
            
            // Position weapon at front of ship
            _laserWeapon.Position = new Vector3(0, 0, -2);
        }
        
        /// <summary>
        /// Called every frame.
        /// Processes player input.
        /// </summary>
        /// <param name="delta">Time since last frame</param>
        public override void _Process(double delta)
        {
            HandleInput();
        }
        
        /// <summary>
        /// Handles all player input for ship movement and weapons.
        /// Processes rotation, thrust, strafing, and firing controls.
        /// </summary>
        private void HandleInput()
        {
            // Rotation controls (Q/E for yaw, A/D for roll, W/S for pitch)
            Vector3 torque = Vector3.Zero;
            
            if (Input.IsActionPressed("pitch_up"))
            {
                torque += Transform.Basis.X * RotationSpeed;
            }
            if (Input.IsActionPressed("pitch_down"))
            {
                torque += -Transform.Basis.X * RotationSpeed;
            }
            if (Input.IsActionPressed("yaw_left"))
            {
                torque += -Transform.Basis.Y * RotationSpeed;
            }
            if (Input.IsActionPressed("yaw_right"))
            {
                torque += Transform.Basis.Y * RotationSpeed;
            }
            if (Input.IsActionPressed("roll_left"))
            {
                torque += -Transform.Basis.Z * RotationSpeed;
            }
            if (Input.IsActionPressed("roll_right"))
            {
                torque += Transform.Basis.Z * RotationSpeed;
            }
            
            if (torque != Vector3.Zero)
            {
                ApplyTorque(torque.Normalized(), 1.0f);
            }
            else
            {
                StopTorque();
            }
            
            // Thrust controls
            Vector3 thrust = Vector3.Zero;
            
            if (Input.IsActionPressed("move_forward"))
            {
                thrust += -Transform.Basis.Z;
            }
            if (Input.IsActionPressed("move_backward"))
            {
                thrust += Transform.Basis.Z;
            }
            
            if (thrust != Vector3.Zero)
            {
                ApplyThrust(thrust.Normalized(), ThrustPower);
            }
            else
            {
                StopThrust();
            }
            
            // Strafing controls
            Vector3 strafe = Vector3.Zero;
            
            if (Input.IsActionPressed("strafe_left"))
            {
                strafe += -Transform.Basis.X;
            }
            if (Input.IsActionPressed("strafe_right"))
            {
                strafe += Transform.Basis.X;
            }
            if (Input.IsActionPressed("strafe_up"))
            {
                strafe += Transform.Basis.Y;
            }
            if (Input.IsActionPressed("strafe_down"))
            {
                strafe += -Transform.Basis.Y;
            }
            
            if (strafe != Vector3.Zero)
            {
                ApplyThrust(strafe.Normalized(), ThrustPower * 0.7f);
            }
            
            // Weapon controls
            if (Input.IsActionPressed("fire_weapon"))
            {
                _laserWeapon?.Fire();
            }
        }
    }
}
