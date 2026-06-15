
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Control Panel</title>

<style>
body {
    margin:0;
    font-family: Arial, sans-serif;
    background:#f0f0f0;
}

/* Header */
.header {
    background:#333;
    color:#fff;
    text-align:center;
    padding:15px;
    font-size:24px;
}

/* Grid layout */
.grid {
    display:grid;
    grid-template-columns: 1fr 1fr;
    gap:12px;
    padding:12px;
}

/* Tiles */
.tile {
    background:#fff;
    border-radius:16px;
    height:120px;
    display:flex;
    flex-direction:column;
    justify-content:center;
    align-items:center;
    font-size:20px;
    border:2px solid #ccc;
}

/* Active state */
.tile.active {
    background:#444;
    color:#fff;
}

/* Footer nav */
.footer {
    position:fixed;
    bottom:0;
    width:100%;
    display:flex;
}

.navbtn {
    flex:1;
    padding:15px;
    font-size:18px;
    border:none;
    background:#ddd;
}
</style>
</head>

<body>

<div class="header">Home Control</div>

<div class="grid">

<div class="tile active">Living Room<br>On</div>
<div class="tile">Kitchen<br>Off</div>

<div class="tile">Bedroom<br>Dim</div>
<div class="tile active">Hallway<br>On</div>

<div class="tile">Heating<br>Off</div>
<div class="tile active">Porch<br>On</div>

</div>

<div class="footer">
<button class="navbtn">Home</button>
<button class="navbtn">Rooms</button>
<button class="navbtn">Settings</button>
</div>

</body>
</html>
