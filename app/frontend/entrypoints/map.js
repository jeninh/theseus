import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "leaflet-arc";

window.L = L;

// Function to create curved path between two points
function createCurvedPath(startLat, startLon, endLat, endLon, numPoints = 20) {
    const points = [];
    
    for (let i = 0; i <= numPoints; i++) {
        const fraction = i / numPoints;
        
        // Simple linear interpolation with a curve offset
        const lat = startLat + (endLat - startLat) * fraction;
        const lon = startLon + (endLon - startLon) * fraction;
        
        // Add curve by offsetting the midpoint
        const distanceFactor = Math.sin(fraction * Math.PI);
        const curvature = 0.3; // Adjust this to control curve height
        const latOffset = distanceFactor * curvature * Math.abs(endLon - startLon) * 0.1;
        
        points.push([lat + latOffset, lon]);
    }
    
    return points;
}

document.addEventListener('DOMContentLoaded', function () {
    // Get map data from JSON script block
    const mapDataElement = document.getElementById('map-data');
    if (!mapDataElement) return;

    const mapData = JSON.parse(mapDataElement.textContent);
    const lettersData = mapData.letters;
    const strokeWidth = mapData.strokeWidth;
    
    console.log('Map data loaded:', { lettersData, strokeWidth });
    console.log('Number of letters:', lettersData ? lettersData.length : 'undefined');
    
    // Debug: Check for invalid coordinates
    lettersData.forEach((letter, index) => {
        if (letter.current_location) {
            const lat = letter.current_location.lat;
            const lon = letter.current_location.lon;
            if (isNaN(lat) || isNaN(lon) || !isFinite(lat) || !isFinite(lon)) {
                console.warn(`Letter ${index} has invalid current_location:`, { lat, lon });
            }
        }
    });

    // Initialize the Leaflet map
    const map = L.map('map', {
        center: [39.8, -98.5], // Center on United States
        zoom: 2,
        worldCopyJump: false
    });

    // Add OpenStreetMap tile layer
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors',
        maxZoom: 18
    }).addTo(map);

    // Create layer groups for different types of elements
    const markersLayer = L.layerGroup().addTo(map);
    const pathsLayer = L.layerGroup().addTo(map);
    const projectionsLayer = L.layerGroup().addTo(map);

    lettersData.forEach(letter => {
        // Add current location marker with letter emoji
        if (letter.current_location && 
            letter.current_location.lat && 
            letter.current_location.lon &&
            !isNaN(letter.current_location.lat) &&
            !isNaN(letter.current_location.lon) &&
            isFinite(letter.current_location.lat) &&
            isFinite(letter.current_location.lon) &&
            letter.current_location.lat >= -90 && letter.current_location.lat <= 90 &&
            letter.current_location.lon >= -180 && letter.current_location.lon <= 180) {
            const isReceived = letter.aasm_state === 'received';
            const letterIcon = L.divIcon({
                html: `<div class="letter-emoji ${isReceived ? 'received-letter' : 'current-letter'}">${isReceived ? '✅' : '✉️'}</div>`,
                className: 'custom-div-icon',
                iconSize: [10, 10],
                iconAnchor: [5, 5]
            });

            const marker = L.marker(
                L.latLng(letter.current_location.lat, letter.current_location.lon),
                { icon: letterIcon }
            );

            if (letter.bubble_title) {
                marker.bindPopup(letter.bubble_title);
            }

            markersLayer.addLayer(marker);
        }

        // Add traveled path (solid green lines)
        const coords = letter.coordinates || [];
        const validCoords = coords.filter(coord => {
            if (!coord || coord.lat == null || coord.lon == null) return false;
            
            const lat = Number(coord.lat);
            const lon = Number(coord.lon);
            
            // Check if numbers are valid and within reasonable ranges
            return !isNaN(lat) && !isNaN(lon) && 
                   isFinite(lat) && isFinite(lon) &&
                   lat >= -90 && lat <= 90 &&
                   lon >= -180 && lon <= 180;
        });

        if (validCoords.length > 1) {
            for (let i = 0; i < validCoords.length - 1; i++) {
                const current = validCoords[i];
                const next = validCoords[i + 1];

                // Double-check coordinates are valid and within Earth bounds
                const currentLat = Number(current.lat);
                const currentLon = Number(current.lon);
                const nextLat = Number(next.lat);
                const nextLon = Number(next.lon);
                
                if (!isNaN(currentLat) && !isNaN(currentLon) && 
                    !isNaN(nextLat) && !isNaN(nextLon) &&
                    isFinite(currentLat) && isFinite(currentLon) &&
                    isFinite(nextLat) && isFinite(nextLon) &&
                    currentLat >= -90 && currentLat <= 90 &&
                    currentLon >= -180 && currentLon <= 180 &&
                    nextLat >= -90 && nextLat <= 90 &&
                    nextLon >= -180 && nextLon <= 180) {
                    
                    try {
                        const polyline = L.polyline([
                            [currentLat, currentLon],
                            [nextLat, nextLon]
                        ], {
                            color: '#00e12c',
                            weight: 1,
                            opacity: 0.8
                        });
                        pathsLayer.addLayer(polyline);
                    } catch (error) {
                        console.error('Error creating polyline:', error, { currentLat, currentLon, nextLat, nextLon });
                    }
                }
            }
        }

        // Add projected path (dashed blue line) from last coordinate to destination
        const lastCoord = validCoords[validCoords.length - 1];
        if (lastCoord && 
            letter.destination_coords && 
            letter.destination_coords.lat &&
            letter.destination_coords.lon &&
            !isNaN(letter.destination_coords.lat) &&
            !isNaN(letter.destination_coords.lon) &&
            isFinite(letter.destination_coords.lat) &&
            isFinite(letter.destination_coords.lon) &&
            letter.aasm_state !== 'received') {
            // Double-check coordinates are valid before creating projected arc
            const lastLat = Number(lastCoord.lat);
            const lastLon = Number(lastCoord.lon);
            const destLat = Number(letter.destination_coords.lat);
            const destLon = Number(letter.destination_coords.lon);
            
            if (!isNaN(lastLat) && !isNaN(lastLon) &&
                !isNaN(destLat) && !isNaN(destLon) &&
                isFinite(lastLat) && isFinite(lastLon) &&
                isFinite(destLat) && isFinite(destLon)) {
                
                try {
                    const projectedPolyline = L.polyline([
                        [lastLat, lastLon],
                        [destLat, destLon]
                    ], {
                        color: '#0f95ef',
                        weight: 1,
                        dashArray: '5, 5',
                        opacity: 0.6
                    });
                    projectionsLayer.addLayer(projectedPolyline);
                } catch (error) {
                    console.error('Error creating projected polyline:', error, { lastLat, lastLon, destLat, destLon });
                }
            }
        }
    });

    // Fit map to show all markers if any exist
    if (markersLayer.getLayers().length > 0) {
        const group = new L.featureGroup([markersLayer, pathsLayer, projectionsLayer]);
        map.fitBounds(group.getBounds().pad(0.1));
    }
});