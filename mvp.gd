extends Node

### MVP — “Black Market Pharmacist”
#
#Goal:
#Make something playable in 1–2 days max.
#
#---
#
## Core Loop
#
#Player has **60 seconds**.
#
#Customers enter one by one.
#
#Each customer:
#
#* says weird symptom
#* player picks 1 of 3 drugs
#* customer reacts instantly
#* gain money or suspicion
#
#Game ends when:
#
#* timer hits 0
  #OR
#* suspicion meter fills
#
#---
#
## Absolute Minimum Features
#
### 1. Single Screen
#
#Only one scene.
#
#Layout:
#
#* customer portrait
#* dialogue text
#* 3 drug buttons
#* money counter
#* suspicion bar
#* timer
#
#No movement.
#No shop decorating.
#No inventory.
#
#---
#
## 2. Fake Illness Generator
#
#Just hardcode 10 symptom lines.
#
#Example:
#
#* “My teeth are vibrating.”
#* “I can hear colors.”
#* “My blood feels cold.”
#* “I forgot where my bones are.”
#
#---
#
## 3. Drug System
#
#Only 3 drugs:
#
#| Drug       | Treats              |
#| ---------- | ------------------- |
#| Red Pills  | pain/weird body     |
#| Blue Syrup | mental/weird senses |
#| Green Shot | energy/fatigue      |
#
#Each symptom secretly maps to correct drug.
#
#---
#
## 4. Outcomes
#
#Correct:
#
#* +$10
#* customer happy
#
#Wrong:
#
#* +suspicion
#* customer gets worse
#
#Inspector customer:
#
#* appears randomly
#* wrong answer = huge suspicion gain
#
#---
#
## 5. Escalation
#
#Every 15 seconds:
#
#* customers appear faster
#
#That alone creates tension.
#
#---
#
## 6. Juice (cheap but effective)
#
#Only add:
#
#* screen shake on mistakes
#* cash sound
#* ticking timer under 15 sec
#* red flash when suspicion rises
#
#Do NOT add:
#
#* crafting
#* walking
#* inventory
#* dialogue trees
#* upgrades
#* save system
#
#---
#
## Recommended Tech (SDT)
#
#If web:
#
#* Phaser
#
#If desktop:
#
#* Godot
#
#If ultra SDT:
#
#* plain HTML/CSS/JS
#
#This is basically:
#
#* arrays
#* timers
#* button clicks
#
#---
#
## Example Data Structure
#
#```js
#{
  #text: "My skin keeps buzzing.",
  #correctDrug: "red"
#}
#```
#
#That’s enough for entire game logic.
#
#---
#
## Replayability
#
#Randomize:
#
#* symptom order
#* inspector timing
#* customer speed
#
#Done.
#
#You already have replay value without more systems.
#
#---
#
## Scope Rule
#
#If a feature takes:
#
#* new UI
#* more than 30 mins
#* more than 1 script
#
#cut it.
#
#The game’s strength is:
#
#* speed
#* pressure
#* absurd symptoms
#* quick decisions
#
#Not depth.
