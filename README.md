# cordova-plugin-contacts
A Cordova Plugin for fetching the Contacts. The official cordova contacts plugin (https://github.com/apache/cordova-plugin-contacts) is deprecated and so this new plugin.

## Supported Platforms
- iOS

## Installation

```cordova plugin add https://github.com/liyamahendra/cordova-plugin-contacts.git```

### iOS Quirks

Since iOS 10 it's mandatory to provide an usage description in the `info.plist` if trying to access privacy-sensitive data. When the system prompts the user to allow access, this usage description string will displayed as part of the permission dialog box, but if you didn't provide the usage description, the app will crash before showing the dialog. Also, Apple will reject apps that access private data but don't provide an usage description.

 This plugins requires the following usage description:

 * `NSContactsUsageDescription` describes the reason that the app accesses the user's contacts.

 To add this entry into the `info.plist`, you can use the `edit-config` tag in the `config.xml` like this:

```
<edit-config target="NSContactsUsageDescription" file="*-Info.plist" mode="merge">
    <string>need contacts access to search friends</string>
</edit-config>
```

### Methods
- `checkPermissions`: To check if the app has permissions to read contacts. It returns a boolean value indicating the status of the permission.
- `getPermissions`: To request permissions to read Contacts
- `fetchContacts`: To read the contacts. The function returns an array of contact objects. A typical Contact object as returned from the plugin is described below:

```
{
    "familyName": "Zakroff",
    "phoneNumbers": [
        "(555) 766-4823",
        "(707) 555-1854"
    ],
    "givenName": "Hank",
    "postalAddresses": [
        {
            "country": "",
            "street": "1741 Kearny Street",
            "postalCode": "94901",
            "city": "San Rafael",
            "state": "CA",
            "subAdministrativeArea": "",
            "subLocality": ""
        }
    ],
    "id": "2E73EE73-C03F-4D5F-B1E8-44E85A70F170",
    "emailAddresses": [
        "hank-zakroff@mac.com"
    ]
}

```