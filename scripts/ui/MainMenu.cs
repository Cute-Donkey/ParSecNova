using Godot;

namespace ParSecNova.UI
{
    public partial class MainMenu : Control
    {
        private Button _startButton;
        private Button _quitButton;
        private Label _titleLabel;

        public override void _Ready()
        {
            CreateUI();
            GD.Print("ParSec Nova - Main Menu initialized");
        }

        private void CreateUI()
        {
            // Title
            _titleLabel = new Label();
            _titleLabel.Text = "ParSec Nova";
            _titleLabel.Position = new Vector2(100, 50);
            _titleLabel.AddThemeStyleboxOverride("normal", new StyleBoxFlat());
            AddChild(_titleLabel);

            // Start Button
            _startButton = new Button();
            _startButton.Text = "Start Game";
            _startButton.Position = new Vector2(100, 150);
            _startButton.Size = new Vector2(200, 50);
            _startButton.Pressed += OnStartPressed;
            AddChild(_startButton);

            // Quit Button
            _quitButton = new Button();
            _quitButton.Text = "Quit";
            _quitButton.Position = new Vector2(100, 220);
            _quitButton.Size = new Vector2(200, 50);
            _quitButton.Pressed += OnQuitPressed;
            AddChild(_quitButton);
        }

        private void OnStartPressed()
        {
            GetTree().ChangeSceneToFile("res://scenes/game/SpaceSector.tscn");
        }

        private void OnQuitPressed()
        {
            GetTree().Quit();
        }
    }
}
