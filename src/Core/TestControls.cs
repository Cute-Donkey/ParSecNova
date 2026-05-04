using Godot;

namespace ParSecNova.Core
{
    public partial class TestControls : Node3D
    {
        private Camera3D _camera;
        private RigidBody3D _ship;
        private RigidBody3D _asteroid;
        private DirectionalLight3D _sun;
        private MeshInstance3D _sunMesh;
        private float _rotationSpeed = 1.0f;
        private float _thrustSpeed = 10.0f;

        // HUD display variables
        private Label _hudLabel;
        private Control _helpDialog;
        private bool _helpVisible = false;

        public override void _Ready()
        {
            _camera = GetNode<Camera3D>("Ship/Camera3D");
            _ship = GetNode<RigidBody3D>("Ship");
            _asteroid = GetNode<RigidBody3D>("Asteroid");
            _sun = GetNode<DirectionalLight3D>("DirectionalLight3D");
            _sunMesh = null;  // Will be set in SetupSun()

            // Position asteroid in front of camera
            var cameraPosition = _camera.GlobalPosition;
            var cameraForward = -_camera.GlobalTransform.Basis.Z;
            var distance = 75.0f;
            _asteroid.GlobalPosition = cameraPosition + cameraForward * distance;

            // Create visible sun
            SetupSun();

            // Create HUD
            SetupHud();

            GD.Print("TestControls initialized!");
        }

        private void SetupSun()
        {
            // Create a visible sun object at the light source position
            var sunMesh = new MeshInstance3D();
            AddChild(sunMesh);

            // Create sphere mesh for sun (realistic size)
            var sphere = new SphereMesh();
            sphere.Radius = 50.0f;  // Much larger - visible from far away
            sphere.Height = 100.0f;
            sunMesh.Mesh = sphere;

            // Create glowing material for sun
            var sunMaterial = new StandardMaterial3D();
            sunMaterial.AlbedoColor = new Color(1.0f, 0.9f, 0.3f, 1.0f);  // Yellow color
            sunMaterial.Emission = new Color(1.0f, 0.9f, 0.3f, 1.0f);  // Glowing effect
            sunMaterial.EmissionIntensity = 10.0f;  // Much brighter
            sunMaterial.DisableFog = true;  // Always visible
            sunMesh.MaterialOverride = sunMaterial;

            // Position sun closer but still far away for visibility
            var sunDirection = -_sun.GlobalTransform.Basis.Z;  // Same direction as light
            sunMesh.GlobalPosition = _sun.GlobalPosition + sunDirection * 1000.0f;  // 1km away
            sunMesh.Name = "SunMesh";

            // Store reference for distance calculation
            _sunMesh = sunMesh;
        }

        private void SetupHud()
        {
            // Create a Control node for HUD
            var hudControl = new Control();
            AddChild(hudControl);

            // Set anchors to top-left
            hudControl.SetAnchorsAndOffsetsPreset(Control.LayoutPreset.TopLeft);

            // Create Label for HUD display
            _hudLabel = new Label();
            hudControl.AddChild(_hudLabel);
            _hudLabel.Position = new Vector2(10, 10);
            _hudLabel.AddThemeFontSizeOverride("font_size", 16);
            _hudLabel.AddThemeColorOverride("font_color", Colors.White);

            // Create modal help dialog (initially hidden)
            _helpDialog = new Control();
            AddChild(_helpDialog);
            _helpDialog.SetAnchorsAndOffsetsPreset(Control.LayoutPreset.FullRect);
            _helpDialog.Visible = false;

            // Create semi-transparent background
            var background = new ColorRect();
            _helpDialog.AddChild(background);
            background.SetAnchorsAndOffsetsPreset(Control.LayoutPreset.FullRect);
            background.Color = new Color(0, 0, 0, 0.8f);  // Dark semi-transparent

            // Create help label
            var helpLabel = new Label();
            _helpDialog.AddChild(helpLabel);
            helpLabel.SetAnchorsAndOffsetsPreset(Control.LayoutPreset.FullRect);
            helpLabel.AddThemeFontSizeOverride("font_size", 16);
            helpLabel.AddThemeColorOverride("font_color", Colors.White);
            helpLabel.HorizontalAlignment = HorizontalAlignment.Center;
            helpLabel.VerticalAlignment = VerticalAlignment.Center;

            // Store reference for help toggle
            // _helpDialog is already set
        }

        public override void _Input(InputEvent @event)
        {
            // Toggle help with F1 key (only on key press, not hold)
            if (@event is InputEventKey keyEvent && keyEvent.Pressed && keyEvent.Keycode == Key.F1)
            {
                ToggleHelp();
            }

            // Quit game with ESC key
            if (@event is InputEventKey escEvent && escEvent.Pressed && escEvent.Keycode == Key.Escape)
            {
                GetTree().Quit();
            }
        }

        public override void _Process(double delta)
        {
            // Emergency stop with S key
            if (Input.IsKeyPressed(Key.S))  // S key
            {
                EmergencyStop();
            }

            // Update HUD display
            UpdateHud();

            // Ship rotation controls
            var rotationInput = Vector3.Zero;

            if (Input.IsActionPressed("ui_left")) {
                rotationInput.Y += _rotationSpeed * (float)delta;
                GD.Print("hallo markus");
            }
            if (Input.IsActionPressed("ui_right"))
                rotationInput.Y -= _rotationSpeed * (float)delta;
            if (Input.IsActionPressed("ui_up"))
                rotationInput.X += _rotationSpeed * (float)delta;
            if (Input.IsActionPressed("ui_down"))
                rotationInput.X -= _rotationSpeed * (float)delta;

            if (rotationInput != Vector3.Zero)
            {
                // Apply torque to RigidBody3D for rotation
                _ship.ApplyTorque(rotationInput * 100.0f);
            }

            // Ship movement controls
            var thrust = Vector3.Zero;

            if (Input.IsActionPressed("ui_accept"))  // Space
                thrust = -_ship.GlobalTransform.Basis.Z * _thrustSpeed;
            else if (Input.IsActionPressed("ui_select"))  // Shift+Space
                thrust = _ship.GlobalTransform.Basis.Z * _thrustSpeed;

            if (thrust != Vector3.Zero)
            {
                _ship.ApplyCentralForce(thrust);
            }
        }

        private void EmergencyStop()
        {
            // Stop all linear velocity
            _ship.LinearVelocity = Vector3.Zero;

            // Stop all angular velocity (rotation around all axes)
            _ship.AngularVelocity = Vector3.Zero;

            // Also clear any accumulated forces and torques
            _ship.ApplyCentralImpulse(-_ship.LinearVelocity);
            _ship.ApplyTorqueImpulse(-_ship.AngularVelocity);

            GD.Print("Emergency stop activated - All ship movement stopped!");
        }

        private void ToggleHelp()
        {
            _helpVisible = !_helpVisible;
            _helpDialog.Visible = _helpVisible;

            if (_helpVisible)
            {
                UpdateHelpDisplay();
                GD.Print("Hilfe angezeigt");
            }
            else
            {
                GD.Print("Hilfe versteckt");
            }
        }

        private void UpdateHelpDisplay()
        {
            if (_helpDialog == null)
                return;

            // Get the help label from the dialog
            var helpLabel = _helpDialog.GetChild<Label>(1);  // Background is child 0, label is child 1

            // Format help text with all key bindings
            var helpText = "=== TASTENBELEGUNGEN ===\n\n";
            helpText += "BEWEGUNG:\n";
            helpText += "Pfeil hoch/runter     - Schiff neigen (Pitch)\n";
            helpText += "Pfeil links/rechts   - Schiff drehen (Yaw)\n";
            helpText += "Leertaste            - Vorwärts schubsen\n";
            helpText += "Umschalt+Leertaste   - Rückwärts schubsen\n\n";
            helpText += "SONDERFUNKTIONEN:\n";
            helpText += "S                    - Notstopp (alle Bewegung)\n";
            helpText += "F1                   - Diese Hilfe ein/aus\n";
            helpText += "ESC                  - Spiel beenden\n\n";
            helpText += "ANZEIGE:\n";
            helpText += "HUD links oben zeigt Echtzeitdaten\n";
            helpText += "Geschwindigkeit, Drehraten, Distanzen\n\n";
            helpText += "Drücke F1 um Hilfe zu schließen";

            helpLabel.Text = helpText;
        }

        private void UpdateHud()
        {
            if (_hudLabel == null)
                return;

            // Get ship velocity
            var velocity = _ship.LinearVelocity;
            var speed = velocity.Length();

            // Get ship angular velocity (rotation speeds)
            var angularVelocity = _ship.AngularVelocity;

            // Calculate distances
            var distanceToAsteroid = _ship.GlobalPosition.DistanceTo(_asteroid.GlobalPosition);
            var distanceToSun = _sunMesh != null ? _ship.GlobalPosition.DistanceTo(_sunMesh.GlobalPosition) : 0.0f;

            // Format HUD text
            var hudText = "=== SCHIFF-DATEN ===\n";
            hudText += $"Geschwindigkeit: {speed:F1} m/s\n";
            hudText += $"Geschw. Vektor: ({velocity.X:F1}, {velocity.Y:F1}, {velocity.Z:F1})\n";
            hudText += "\n=== DREHRATEN ===\n";
            hudText += $"X-Achse (Pitch): {angularVelocity.X:F3} rad/s\n";
            hudText += $"Y-Achse (Yaw): {angularVelocity.Y:F3} rad/s\n";
            hudText += $"Z-Achse (Roll): {angularVelocity.Z:F3} rad/s\n";
            hudText += "\n=== OBJEKTE ===\n";
            hudText += $"Sonne Distanz: {distanceToSun:F1} m\n";
            hudText += $"Asteroid Distanz: {distanceToAsteroid:F1} m";

            // Add help hint if help is not visible
            if (!_helpVisible)
            {
                hudText += "\n\n[F1 für Hilfe]";
            }

            _hudLabel.Text = hudText;
        }
    }
}
