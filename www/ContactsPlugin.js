var exec = require('cordova/exec');

exports.checkPermissions = function (success, error) {
    exec(success, error, 'ContactsPlugin', 'checkPermissions', []);
};

exports.getPermissions = function (success, error) {
    exec(success, error, 'ContactsPlugin', 'getPermissions', []);
};

exports.fetchContacts = function (success, error) {
    exec(success, error, 'ContactsPlugin', 'fetchContacts', []);
};
