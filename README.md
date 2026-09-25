# Grain Tag GTM Template

A Google Tag Manager (GTM) custom template for [Grain](https://grainql.com) analytics.

## Tag types

### Initialization

This tag loads the Grain SDK and sets its config. Fire it on **All Pages**, or on a trigger of your choice. It must run before any Custom Event or Identify User tag.

| Field | Required | Description |
|-------|----------|-------------|
| Tenant ID | Yes | Your Grain tenant ID |
| API URL | No | Replaces the default API endpoint |
| Consent Mode | No | `auto` (default), `opt-in`, or `opt-out` |
| Page Views | No | Track page views (default: on) |
| Heatmaps | No | Track clicks and scrolls (default: on) |
| Snapshots | No | Capture DOM snapshots (default: on) |
| Debug Mode | No | Write logs to the console (default: off) |

### Custom Event

This tag sends a custom event with optional properties. An Initialization tag must fire first.

| Field | Required | Description |
|-------|----------|-------------|
| Event Name | Yes | For example `signup`, `purchase`, or `add_to_cart` |
| Event Properties | No | Key-value pairs sent with the event |

### Identify User

This tag connects the current visitor to a known user ID. An Initialization tag must fire first.

| Field | Required | Description |
|-------|----------|-------------|
| User ID | Yes | Your internal user ID |

## Setup

### Option 1: Import the template file

1. In GTM, go to **Templates** > **Tag Templates** > **New**.
2. Open the **three-dot menu**. Select **Import**.
3. Select `template.tpl` from this directory.
4. Save the template.

### Option 2: Manual setup

1. In GTM, create a new Tag Template.
2. Copy each section of `template.tpl` into the matching editor tab.

## Usage

1. Create an **Initialization** tag with your Tenant ID. Trigger it on All Pages.
2. Create a **Custom Event** tag for each interaction that you want to track, for example button clicks or form submissions.
3. If you want to identify users, create an **Identify User** tag that fires when a user logs in.

## How it works

The Initialization tag sets `window.__GRAIN_CONFIG__` and loads the SDK from `https://tag.grainql.com/v4/{tenantId}.js`. The SDK starts from that config. The Custom Event and Identify User tags call `track()` and `identify()` on the `window.GrainTag` global.
