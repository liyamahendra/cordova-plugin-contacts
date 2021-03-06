import Contacts


@objc(ContactsPlugin) class ContactsPlugin : CDVPlugin, UIActionSheetDelegate {

    var _callbackId: String?

    @objc(pluginInitialize)
    override func pluginInitialize() {
        super.pluginInitialize();
    }

    @objc(fetchContacts:)
    func fetchContacts(command: CDVInvokedUrlCommand) {
        _callbackId = command.callbackId;

        var response = [Any]()
        let contacts = _fetchContacts()

        for contact in contacts {
            response.append(toDictionary(contact: contact))
        }

        var pluginResult: CDVPluginResult

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: response);

        self.commandDelegate!.send(pluginResult, callbackId: self._callbackId);
    }

    @objc(checkPermissions:)
    func checkPermissions(command: CDVInvokedUrlCommand) {
        _callbackId = command.callbackId;

        self.hasPermission { (granted) in
            let dict = [
                "read": granted
            ];

            let result:CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: dict);
            self.commandDelegate.send(result, callbackId: self._callbackId)
        }
    }

    @objc(getPermissions:)
    func getPermissions(command: CDVInvokedUrlCommand) {
        _callbackId = command.callbackId

        let store = CNContactStore();
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                let result:CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "");
                self.commandDelegate.send(result, callbackId: self._callbackId)
            } else {
                let result:CDVPluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error?.localizedDescription);
                self.commandDelegate.send(result, callbackId: self._callbackId)
            }
        }
    }

    func hasPermission(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                completionHandler(true)
            case .denied, .restricted, .notDetermined:
                completionHandler(false)
        }
    }
}

extension ContactsPlugin {
    func _fetchContacts() -> [CNContact] {
        do {
            let store = CNContactStore()
            let keysToFetch = [
                CNContactIdentifierKey as CNKeyDescriptor,
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactNicknameKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor
            ]

            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            var contacts = [CNContact]()

            try store.enumerateContacts(with: request) {
                (contact, stop) in contacts.append(contact)
            }


            contacts.sort {
                $0.familyName > $1.familyName
            }

            return contacts

        } catch {
            print(error.localizedDescription)
            return []
        }
    }


    func toDictionary(contact: CNContact)->[String:Any]{
        var contactDict = [String:Any]()
        contactDict["id"] = contact.identifier
        contactDict["givenName"] = contact.givenName
        contactDict["familyName"] = contact.familyName
        contactDict["nickName"] = contact.nickname
            
        let formatter = CNContactFormatter()
        formatter.style = .fullName
        
        if let name = formatter.string(from: contact) {
            contactDict["displayName"] = name
        }

        if contact.phoneNumbers.count > 0 {
            var phoneNumbers = [String]()
            for (_, phoneNumber) in contact.phoneNumbers.enumerated() {
                phoneNumbers.append(phoneNumber.value.stringValue)
            }
            contactDict["phoneNumbers"] = phoneNumbers
        }

        return contactDict
    }
}
