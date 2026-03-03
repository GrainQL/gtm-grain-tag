# Grain Tag - GTM Template

Google Tag Manager custom template for [Grain](https://grainql.com) analytics.

## Tag Types

### Initialization

Loads the Grain SDK and configures it. Fire this on **All Pages** (or your desired trigger) so it runs before any event/identify tags.

| Field | Required | Description |
|-------|----------|-------------|
| Tenant ID | Yes | Your Grain tenant ID |
| API URL | No | Override the default API endpoint |
| Consent Mode | No | `auto` (default), `opt-in`, or `opt-out` |
| Page Views | No | Auto-track page views (default: on) |
| Heatmaps | No | Enable heatmap tracking (default: on) |
| Snapshots | No | Enable DOM snapshots (default: on) |
| Debug Mode | No | Enable console logging (default: off) |

### Custom Event

Sends a custom event with optional properties. Requires an Initialization tag to have fired first.

| Field | Required | Description |
|-------|----------|-------------|
| Event Name | Yes | e.g. `signup`, `purchase`, `add_to_cart` |
| Event Properties | No | Key-value pairs sent with the event |

### Identify User

Associates the current visitor with a known user ID. Requires an Initialization tag to have fired first.

| Field | Required | Description |
|-------|----------|-------------|
| User ID | Yes | Your internal user identifier |

## Setup

### Option 1: Import the template file

1. In GTM, go to **Templates** > **Tag Templates** > **New**
2. Click the **three-dot menu** > **Import**
3. Select `template.tpl` from this directory
4. Save the template

### Option 2: Manual setup

1. In GTM, create a new Tag Template
2. Copy the contents of each section from `template.tpl` into the corresponding editor tabs

## Usage

1. Create an **Initialization** tag with your Tenant ID, triggered on All Pages
2. Create **Custom Event** tags for specific interactions (button clicks, form submissions, etc.)
3. Optionally create an **Identify** tag that fires when a user logs in

## How It Works

The Initialization tag sets `window.__GRAIN_CONFIG__` and injects the SDK from `https://tag.grainql.com/v4/{tenantId}.js`. The SDK auto-initializes from that config. Event and Identify tags call the SDK's `track()` and `identify()` methods through the `window.GrainTag` global.
