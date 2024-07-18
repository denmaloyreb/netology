<style>
    .cube {
      position: relative;
      width: 200px;
      height: 200px;
      transform-style: preserve-3d;
      transform: rotateX(45deg) rotateY(45deg);
    }
    .face {
      position: absolute;
      width: 200px;
      height: 200px;
      border: 2px solid black;
    }
    .front  { transform: translateZ(100px); background-color: #ffcc00; }
    .back   { transform: rotateY(180deg) translateZ(100px); background-color: #ff6600; }
    .right  { transform: rotateY(90deg) translateZ(100px); background-color: #0099cc; }
    .left   { transform: rotateY(-90deg) translateZ(100px); background-color: #33cc33; }
    .top    { transform: rotateX(90deg) translateZ(100px); background-color: #cc00cc; }
    .bottom { transform: rotateX(-90deg) translateZ(100px); background-color: #993399; }
</style>

# Куб

<div class="cube">
    <div class="face front"></div>
    <div class="face back"></div>
    <div class="face right"></div>
    <div class="face left"></div>
    <div class="face top"></div>
    <div class="face bottom"></div>
</div>
