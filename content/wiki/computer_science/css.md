---
title: "Css"
description: "About css."
---

# Flexbox

## Resources

A way to organize items as movable elements in CSS.
 * [Guide](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

# Grid

## Center elements

```css
display: grid;
place-items: center;
```

## Resources

A way to organize items in Css as grids
* [Guide](https://css-tricks.com/snippets/css/complete-guide-grid/)

# Fonts

## Resources

* [Google fonts](https://fonts.google.com)

# Charts

## Resources

* [Charts.css](https://chartscss.org/)

# Custom components

## Create a homemade radio button

- Thanks Pierre-Louis for the trick:
```html
      <label class="order-radio selected">
        <div class="circle selected">
          <div class="inside-circle"></div>
        </div>
        <input type="radio" checked="true" name="radio" />
        <p>Livraison gratuite (5 jours ouvrés)</p>
      </label>
```
```css
  .circle {
    width: 32px;
    height: 32px;
    border-radius: 50%;

    background: #aaaaaa;

    display: grid;
    place-items: center;
  }

  .inside-circle {
    width: 13px;
    height: 13px;
    border-radius: 50%;

    background-color: white;
    box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.25);
  }
```

# Resources

* [Defensive CSS](https://ishadeed.com/article/defensive-css/): protect yourself against bad CSS behaviour
* [Visual Design Rules](https://anthonyhobday.com/sideprojects/saferules/)
