---
name: tv-center
description: TV center orchestration — UC Remote 3, Broadlink RM4 Pro, HA scripts for movie night, gaming, TV broadcast, and all-off. Controls LG TV, NVIDIA Shield, Xbox, Orange TV, Hue Sync Box 8K, Devialet Dione, and Hue lights.
---

## Overview

The TV center is orchestrated through Home Assistant with an Unfolded Circle Remote 3 as the physical interface.

Architecture:
```
UC Remote 3 ←→ Home Assistant ←→ All Devices
```

Physical wiring:
```
Shield / Xbox / Switch / Orange TV → Hue Sync Box 8K → LG TV (eARC) → Devialet Dione
```

## Devices & Entities

| Device | HA Entity | Control Method |
|---|---|---|
| LG webOS TV | `media_player.tv` | webOS integration (WoL, source, volume) |
| NVIDIA Shield | `media_player.nvidia_shield` | Android TV integration |
| Devialet Dione | `media_player.devialet_dione` | AirPlay/DLNA |
| Hue Sync Box 8K power | `switch.hue_sync_box_8k_power` | Hue integration |
| Hue Sync Box light sync | `switch.hue_sync_box_8k_light_sync` | Hue integration |
| Hue Sync Box input | TBD (verify entity) | Hue integration |
| Orange TV box | Via Broadlink IR | Broadlink RM4 Pro |
| Xbox | Via Broadlink IR | Broadlink RM4 Pro |
| Hue Play Gradient TV | `light.hue_play_gradient_tv` | Hue integration |
| UC Remote 3 | HACS integration | Delegates to HA |

## Hardware to Buy

| Item | Price | Purpose |
|---|---|---|
| Unfolded Circle Remote 3 | ~€350 | Physical remote, HA interface |
| Broadlink RM4 Pro | ~€40 | IR blaster for Orange TV + Xbox |
| 3.5mm IR emitter cables (x2) | ~€10 | Reach devices inside cabinet |

## HA Scripts

### script.tv_center_movie
```yaml
sequence:
  - service: media_player.turn_on
    target:
      entity_id: media_player.tv
  - service: media_player.turn_on
    target:
      entity_id: media_player.nvidia_shield
  # Sync Box → Shield input (verify entity + source name)
  - service: media_player.turn_on
    target:
      entity_id: media_player.devialet_dione
  - service: media_player.volume_set
    target:
      entity_id: media_player.devialet_dione
    data:
      volume_level: 0.35
  - service: light.turn_on
    target:
      entity_id: light.hue_play_gradient_tv
  - service: scene.turn_on
    target:
      entity_id: scene.living_room_neon_dreams
```

### script.tv_center_xbox
```yaml
sequence:
  - service: media_player.turn_on
    target:
      entity_id: media_player.tv
  # Broadlink → Xbox power on IR
  # Sync Box → Xbox input (verify entity + source name)
  - service: media_player.turn_on
    target:
      entity_id: media_player.devialet_dione
  - service: scene.turn_on
    target:
      entity_id: scene.living_room_neon_dreams
```

### script.tv_center_switch
```yaml
sequence:
  - service: media_player.turn_on
    target:
      entity_id: media_player.tv
  # Sync Box → Switch input (verify entity + source name)
  - service: media_player.turn_on
    target:
      entity_id: media_player.devialet_dione
  - service: scene.turn_on
    target:
      entity_id: scene.living_room_neon_wave
```

### script.tv_center_tv
```yaml
sequence:
  - service: media_player.turn_on
    target:
      entity_id: media_player.tv
  # Broadlink → Orange TV power on IR
  # Sync Box → Orange TV input (verify entity + source name)
  - service: media_player.turn_on
    target:
      entity_id: media_player.devialet_dione
  - service: media_player.volume_set
    target:
      entity_id: media_player.devialet_dione
    data:
      volume_level: 0.3
  - service: scene.turn_on
    target:
      entity_id: scene.living_room_relax
```

### script.tv_center_off
```yaml
sequence:
  - service: media_player.turn_off
    target:
      entity_id: media_player.tv
  - service: media_player.turn_off
    target:
      entity_id: media_player.nvidia_shield
  # Broadlink → Orange TV power off IR
  # Broadlink → Xbox power off IR
  - service: media_player.turn_off
    target:
      entity_id: media_player.devialet_dione
  - service: switch.turn_off
    target:
      entity_id: switch.hue_sync_box_8k_power
  - service: light.turn_off
    target:
      area_id: living_room
```

## UC Remote 3 Activities

Map scripts to remote activities on the UC Remote 3:
- **Movie** → triggers `script.tv_center_movie`
- **Xbox** → triggers `script.tv_center_xbox`
- **Switch** → triggers `script.tv_center_switch`
- **TV** → triggers `script.tv_center_tv`
- **All Off** → triggers `script.tv_center_off`
- Volume buttons → control `media_player.devialet_dione`
- Light scene quick-switcher page

## Living Room Scenes

| Scene | Entity ID | Use Case |
|---|---|---|
| Neon Dreams | `scene.living_room_neon_dreams` | Movie/Gaming ambient |
| Neon Wave | `scene.living_room_neon_wave` | Switch gaming |
| Relax | `scene.living_room_relax` | TV watching |
| Nightlight | `scene.living_room_nightlight` | Low-light |
| Bright | `scene.living_room_bright` | General lighting |

## Setup Checklist

- [ ] Buy UC Remote 3, Broadlink RM4 Pro, IR emitter cables
- [ ] Set up Broadlink RM4 Pro (Broadlink app → HA integration)
- [ ] Learn Orange TV IR codes (power, ch, vol, directional)
- [ ] Learn Xbox IR codes (power on/off)
- [ ] Place IR emitters in cabinet near Orange TV and Xbox
- [ ] Set up UC Remote 3 (WiFi, firmware update, HACS integration)
- [ ] Find Sync Box input entity in HA
- [ ] Create HA scripts (fill in TBD placeholders)
- [ ] Map scripts to UC Remote 3 activities
- [ ] Test all scenarios
- [ ] Design backup dashboard (phone/tablet)

## Notes

- Xbox is controlled via IR (not native HA integration) — Broadlink handles power on/off
- Orange TV is IR-only — needs Broadlink + IR emitter in cabinet
- UC Remote 3 WiFi wake-up delay (~7-10s) can be mitigated by enabling "Keep WiFi connected in standby" (shorter battery but instant wake) or keeping it on the dock
- No CEC — user finds it unreliable, all control goes through HA
- Hue Sync Box source selection entity needs to be identified during setup
