const hudData = {
    health: 100,
    armor: 100,
    hunger: 100,
    thirst: 100,
    stamina: 100,
    oxygen: 100,
    speed: 0,
    fuel: 100,
    cash: 0,
    bank: 0,
    blackmoney: 0,
    role: '',
    grade: '',
    weapon: 'Desarmado',
    ammo: 0,
    inVehicle: false
};

let isHUDVisible = true;

window.addEventListener('message', function(event) {
    const { action, data } = event.data;
    switch (action) {
        case 'updateHUD':
            if (data) {
                Object.assign(hudData, data);
                updateHUD();
            }
            break;
        case 'updateRole':
            if (data && data.role && data.grade) {
                hudData.role = data.role || 'Sin trabajo';
                hudData.grade = data.grade || '0';
                updateRole();
            }
            break;
        case 'updateMoney':
            if (data) {
                Object.assign(hudData, data);
                updateHUD();
            }
            break;
        case 'updateSpeed':
            if (data) {
                hudData.speed = data.speed || 0;
                hudData.fuel = data.fuel || 0;
                hudData.inVehicle = data.inVehicle || false;
                updateSpeed();
            }
            break;
        case 'updateWeapon':
            if (data) {
                hudData.weapon = data.weapon || 'Desarmado';
                hudData.ammo = data.ammo || 0;
                updateWeapon();
            }
            break;
        case 'toggleHUD':
            if (data && data.visible !== undefined) {
                isHUDVisible = data.visible;
                toggleHUDVisibility();
            }
            break;
    }
});

function toggleHUDVisibility() {
    const hudElement = document.getElementById('qb-hud');
    if (hudElement) {
        hudElement.style.display = isHUDVisible ? 'block' : 'none';
    }
}

function updateRole() {
    const jobInfoElement = document.querySelector('.job-info');
    if (jobInfoElement) {
        jobInfoElement.textContent = `${hudData.role} | ${hudData.grade}`;
    }
}

function updateHUD() {
    updateStatusBar('health', hudData.health);
    updateStatusBar('armor', hudData.armor);
    updateStatusBar('hunger', hudData.hunger);
    updateStatusBar('thirst', hudData.thirst);
    updateStatusBar('stamina', hudData.stamina);
    updateStatusBar('oxygen', hudData.oxygen);
    document.getElementById('cash').querySelector('span').textContent = `$${hudData.cash}`;
    document.getElementById('people').querySelector('span').textContent = `$${hudData.blackmoney}`;
    document.getElementById('bank').querySelector('span').textContent = `$${hudData.bank}`;
}

function updateStatusBar(id, value) {
    const statusBar = document.querySelector(`.status-bar.${id}`);
    const bar = document.getElementById(`${id}-bar`);
    
    if (bar) {
        bar.style.width = `${value}%`;
        
        if (id === 'armor') {
            statusBar.style.display = value > 1 ? 'flex' : 'none';
            return;
        }
        
        if (value === 100) {
            statusBar.style.display = 'none';
        } else if (value < 99) {
            statusBar.style.display = 'flex';
        }
    }
}

function updateWeapon() {
    const weaponInfo = document.getElementById('weapon-info');
    const ammoInfo = document.getElementById('ammo-info');

    if (weaponInfo && ammoInfo) {
        weaponInfo.textContent = hudData.weapon;
        ammoInfo.textContent = hudData.weapon !== 'Desarmado' ? `${hudData.ammo} 🔸` : '';
    }
}

function updateSpeed() {
    const speedElement = document.getElementById('speed');
    const vehicleContainer = document.querySelector('.vehicle-container');

    if (hudData.inVehicle === true) {
        speedElement.textContent = `${Math.round(hudData.speed)} km/h`;
        vehicleContainer.style.display = 'block';
        const fuelBar = document.getElementById('fuel-bar');
        if (fuelBar) {
            fuelBar.style.width = `${hudData.fuel}%`;
            if (hudData.fuel <= 20) {
                fuelBar.style.background = '#ff0000'; 
            } else if (hudData.fuel <= 40) {
                fuelBar.style.background = '#ff9900'; 
            } else {
                fuelBar.style.background = '#0088ff';
            }
        }
    } else {
        vehicleContainer.style.display = 'none';
    }
}