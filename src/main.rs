use bevy::prelude::*;
use serde::Deserialize;
use std::fs;

// --- DATA STRUCTURES (JSON Mapping) ---

#[derive(Deserialize, Debug)]
enum EntityType { Light, Asteroid, Ship }

#[derive(Deserialize, Debug)]
struct SceneEntity {
    #[allow(dead_code)] // <--- This disables the warning only for this field
    name: String,       // Now it can be called "name" again (without underscore)
    entity_type: EntityType,
    position: [f32; 3],
    #[serde(default)] mass: f32,
    #[serde(default)] intensity: f32,
    #[serde(default)] radius: f32,
}

#[derive(Deserialize, Debug)]
struct WorldData {
    entities: Vec<SceneEntity>,
}

// --- BEVY COMPONENTS ---

#[derive(Component)]
struct NewtonianBody {
    velocity: Vec3,
    mass: f32,
}

#[derive(Component)]
struct PlayerShip;

// --- SYSTEMS ---

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_systems(Startup, load_world_from_json)
        .add_systems(Update, (apply_physics, player_input))
        .run();
}

fn load_world_from_json(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
) {
    // Read JSON
    let data = fs::read_to_string("assets/world.json").expect("JSON not found!");
    let world: WorldData = serde_json::from_str(&data).expect("JSON error!");

    for ent in world.entities {
        let pos = Vec3::from_array(ent.position);
        
        match ent.entity_type {
            EntityType::Light => {
                commands.spawn(PointLightBundle {
                    point_light: PointLight { intensity: ent.intensity, shadows_enabled: true, ..default() },
                    transform: Transform::from_translation(pos),
                    ..default()
                });
            }
            EntityType::Asteroid => {
                commands.spawn(PbrBundle {
                    mesh: meshes.add(Sphere::new(ent.radius)),
                    material: materials.add(Color::srgb(0.4, 0.3, 0.2)),
                    transform: Transform::from_translation(pos),
                    ..default()
                });
            }
            EntityType::Ship => {
                commands.spawn((
                    PbrBundle {
                        mesh: meshes.add(Cuboid::new(1.0, 0.5, 2.0)),
                        material: materials.add(Color::srgb(0.0, 0.8, 1.0)),
                        transform: Transform::from_translation(pos),
                        ..default()
                    },
                    PlayerShip,
                    NewtonianBody { velocity: Vec3::ZERO, mass: ent.mass },
                ));
            }
        }
    }

    // Camera Setup
    commands.spawn(Camera3dBundle {
        transform: Transform::from_xyz(0.0, 15.0, 30.0).looking_at(Vec3::ZERO, Vec3::Y),
        ..default()
    });
}

fn player_input(
    keyboard: Res<ButtonInput<KeyCode>>,
    mut query: Query<&mut NewtonianBody, With<PlayerShip>>,
    time: Res<Time>,
) {
    if let Ok(mut body) = query.get_single_mut() {
        let thrust = 5000.0;
        if keyboard.pressed(KeyCode::KeyW) {
            body.velocity.z -= (thrust / body.mass) * time.delta_seconds();
        }
    }
}

fn apply_physics(mut query: Query<(&mut Transform, &NewtonianBody)>, time: Res<Time>) {
    for (mut trans, body) in query.iter_mut() {
        trans.translation += body.velocity * time.delta_seconds();
    }
}