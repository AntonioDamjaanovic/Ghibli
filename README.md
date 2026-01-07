# Ghibli - iOS App with REST API

the project was build with the following:
- iOS 26+
- SwiftUI with Observation feature for better performance
- URLSession with async/await
- MVVM with service layer
- testing with Swift Testing

API [documentation](https://ghibliapi.vercel.app/) for Studio Ghibli:
- base URL: https://ghibliapi.vercel.app/
- endpoints used: /films /people
- no authentication required

## ✨ Features of the Project

- TabView with Navigation Stacks
- List Screen (fetch from API, show list of items).
- Detail Screen (display more info, async image loading).
- Favorites (local persistence).
- Search (filter + async debounce).
- Settings (theme, stored in UserDefaults).
- Testing, mocks, & dependency injection

## 📸 Screenshots
  
<div style="display:flex; gap:16px;">
  <img src="images/ghibli_movie_list.jpeg" width="200" height="1000"/>
  <img src="/images/ghibli_movie_detail.jpeg" width="200" height="1000"/>
  <img src="/images/ghibli_favorites.jpeg" width="200" height="1000"/>
</div>

<div style="display:flex; gap:16px; margin-top:16px;">
  <img src="/images/ghibli_search.jpeg" width="200" height="1000"/>
  <img src="/images/ghibli_settings.jpeg" width="200" height="1000"/>
</div>
