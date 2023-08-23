# Map

1. Implemented iOS framework mapKit for map view in the app's user interface.
2. Initial location on the map is set to New York, NY, USA(API data is of USA).
3. Button present on the map interface allows the user to view their current location.
4. University location data is fetched from the ArcGIS API using the provided API URL.<ArcGIS Location API:
https://services2.arcgis.com/5I7u4SJE1vUr79JC/arcgis/rest/services/UniversityChapters_Public/Feat
ureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json>
5. Parsed the JSON response received from the API.
6. Added supprot for dynamic field of view(zoom size).
7. University locations on the map displayed using markers or annotations for each location.
8. When the user taps on a university location marker, a route from the user's current location to the selected university is showed.
9. University details, such as name, distance from the user's current location, state, etc. is also displayed on tap on university annotation.
10. If a route is not found from the user's location to a university, a message dispalyed stating that the route could not be found.

UI video: https://drive.google.com/file/d/1l7CkTr3ZZuFRo7UVykCzOdvEGpjgqnbH/view?usp=share_link
