---
name: home-assistant
description: Home Assistant automation, device control, and status checking via MCP.
---

# home-assistant — smart home control

This skill provides guidance for interacting with Home Assistant via the MCP server.

## Usage

Use this skill when:
- Checking device status (lights, sensors, locks, etc.)
- Automating home devices
- Creating or modifying automations
- Debugging home assistant issues

## MCP Server

- URL: `https://home.wagou.fr/api/mcp`
- Authentication: Handled via MCP protocol

## Common Operations

### Check Device Status
```
Use the home-assistant MCP to get the state of entities
```

### Control Devices
```
Use the home-assistant MCP to call services (light.turn_on, switch.toggle, etc.)
```

### List Available Entities
```
Use the home-assistant MCP to list all entities with their states
```

## Tips

- Entity IDs follow the pattern: `domain.object_name` (e.g., `light.kitchen`, `sensor.temperature`)
- Use `area` to group devices by room
- Check the `last_changed` timestamp for freshness
