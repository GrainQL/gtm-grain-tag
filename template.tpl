___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "grain_tag",
  "version": 1,
  "securityGroups": [],
  "displayName": "Grain Tag",
  "brand": {
    "id": "grain",
    "displayName": "Grain"
  },
  "categories": ["ANALYTICS", "ATTRIBUTION", "CONVERSIONS", "DATA_WAREHOUSING", "HEAT_MAP", "MARKETING", "SESSION_RECORDING"],
  "description": "Send events to Grain analytics. Supports initialization, custom event tracking, and user identification.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "tagType",
    "displayName": "Tag Type",
    "macrosInSelect": false,
    "selectItems": [
      { "value": "init", "displayValue": "Initialization" },
      { "value": "event", "displayValue": "Custom Event" },
      { "value": "identify", "displayValue": "Identify User" }
    ],
    "simpleValueType": true,
    "defaultValue": "init",
    "help": "Choose the action this tag should perform."
  },
  {
    "type": "TEXT",
    "name": "tenantId",
    "displayName": "Tenant ID",
    "simpleValueType": true,
    "valueValidators": [
      { "type": "NON_EMPTY" }
    ],
    "help": "Your Grain tenant ID (UUID or alias).",
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "TEXT",
    "name": "apiUrl",
    "displayName": "API URL (optional)",
    "simpleValueType": true,
    "help": "Override the default API endpoint. Leave blank to use the default (https://clientapis.grainql.com).",
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "SELECT",
    "name": "consentMode",
    "displayName": "Consent Mode",
    "macrosInSelect": false,
    "selectItems": [
      { "value": "auto", "displayValue": "Auto (default)" },
      { "value": "opt-in", "displayValue": "Opt-in" },
      { "value": "opt-out", "displayValue": "Opt-out" }
    ],
    "simpleValueType": true,
    "defaultValue": "auto",
    "help": "Controls how the SDK handles user consent.",
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "enablePageViews",
    "checkboxText": "Enable automatic page view tracking",
    "simpleValueType": true,
    "defaultValue": true,
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "enableHeatmaps",
    "checkboxText": "Enable heatmap tracking",
    "simpleValueType": true,
    "defaultValue": true,
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "enableSnapshots",
    "checkboxText": "Enable DOM snapshots",
    "simpleValueType": true,
    "defaultValue": true,
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "debugMode",
    "checkboxText": "Enable debug mode",
    "simpleValueType": true,
    "defaultValue": false,
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "init", "type": "EQUALS" }
    ]
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event Name",
    "simpleValueType": true,
    "valueValidators": [
      { "type": "NON_EMPTY" }
    ],
    "help": "The name of the event to send (e.g. 'signup', 'purchase').",
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "event", "type": "EQUALS" }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "eventProperties",
    "displayName": "Event Properties",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Property Name",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "value",
        "type": "TEXT"
      }
    ],
    "help": "Key-value pairs to send with the event.",
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "event", "type": "EQUALS" }
    ]
  },
  {
    "type": "TEXT",
    "name": "userId",
    "displayName": "User ID",
    "simpleValueType": true,
    "valueValidators": [
      { "type": "NON_EMPTY" }
    ],
    "help": "The user ID to associate with this visitor.",
    "enablingConditions": [
      { "paramName": "tagType", "paramValue": "identify", "type": "EQUALS" }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const copyFromWindow = require('copyFromWindow');
const callInWindow = require('callInWindow');
const makeTableMap = require('makeTableMap');

var SDK_BASE_URL = 'https://tag.grainql.com/v4/';

// Route to the right handler based on tag type
if (data.tagType === 'init') {
  handleInit();
} else if (data.tagType === 'event') {
  handleEvent();
} else if (data.tagType === 'identify') {
  handleIdentify();
} else {
  log('Grain Tag: Unknown tag type:', data.tagType);
  data.gtmOnFailure();
}

function handleInit() {
  // Build config and set it on window before loading the SDK
  var config = {
    tenantId: data.tenantId,
    consentMode: data.consentMode || 'auto',
    enablePageViews: data.enablePageViews !== false,
    enableHeatmaps: data.enableHeatmaps !== false,
    enableSnapshots: data.enableSnapshots !== false,
    debug: data.debugMode || false
  };

  if (data.apiUrl) {
    config.apiUrl = data.apiUrl;
  }

  // Set config on window for the SDK to read during init
  setInWindow('__GRAIN_CONFIG__', config, true);

  var sdkUrl = SDK_BASE_URL + data.tenantId + '.js';

  injectScript(sdkUrl, function() {
    log('Grain Tag: SDK loaded successfully');
    data.gtmOnSuccess();
  }, function() {
    log('Grain Tag: Failed to load SDK');
    data.gtmOnFailure();
  }, 'grainTagSdk');
}

function isGrainReady() {
  return !!copyFromWindow('GrainTag');
}

function handleEvent() {
  if (!isGrainReady()) {
    log('Grain Tag: SDK not initialized. Add an Initialization tag that fires before this event tag.');
    data.gtmOnFailure();
    return;
  }

  var properties = {};
  if (data.eventProperties) {
    properties = makeTableMap(data.eventProperties, 'key', 'value');
  }

  callInWindow('GrainTag.track', data.eventName, properties);
  data.gtmOnSuccess();
}

function handleIdentify() {
  if (!isGrainReady()) {
    log('Grain Tag: SDK not initialized. Add an Initialization tag that fires before this identify tag.');
    data.gtmOnFailure();
    return;
  }

  callInWindow('GrainTag.identify', data.userId);
  data.gtmOnSuccess();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "vpiId": "2"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://tag.grainql.com/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiId": "3"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "__GRAIN_CONFIG__" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "GrainTag" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": false }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "GrainTag.init" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "GrainTag.track" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  { "type": 1, "string": "key" },
                  { "type": 1, "string": "read" },
                  { "type": 1, "string": "write" },
                  { "type": 1, "string": "execute" }
                ],
                "mapValue": [
                  { "type": 1, "string": "GrainTag.identify" },
                  { "type": 8, "boolean": true },
                  { "type": 8, "boolean": false },
                  { "type": 8, "boolean": true }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2026-03-03.

Grain Tag - Google Tag Manager Custom Template
https://grainql.com
