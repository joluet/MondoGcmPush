# MondoGcmPush
A small Sinatra server that converts transaction webhook notifications
from the [Mondo API](https://getmondo.co.uk/docs) into GCM push notifications.


This is used to enable push notifications for the [MondoAndroid app](https://github.com/joluet/MondoAndroid).

This Sinatra app stores pairs of GCM registration ids and Mondo account ids that are send to the `/token` endpoint as a `PUT` request. The body of such a `PUT` request should look like this:
```json
{
"account_id": "a_mondo_account_id", 
"token" :     "a_gcm_registration_id"
}
```

The app then forwards the body of any `POST` request that is send to `/push` in form of a GCM push notification to a registration id that corresponds to the Mondo account id provided in the body of the `POST` request. The Mondo API sends such a `POST` request to registered webhooks when a new transaction has been created. See the [Mondo API docs](https://getmondo.co.uk/docs/#webhooks) for details. The body is expected to look like this:
```json
{
    "type": "transaction.created",
    "data": {
        "account_id": "a_mondo_account_id",
        "amount": -350,
        "created": "2015-09-04T14:28:40Z",
        "currency": "GBP",
        "description": "Ozone Coffee Roasters",
        "id": "tx_00008zjky19HyFLAzlUk7t",
        "category": "eating_out",
        "is_load": false,
        "settled": true,
        "merchant": {
            "address": {
                "address": "98 Southgate Road",
                "city": "London",
                "country": "GB",
                "latitude": 51.54151,
                "longitude": -0.08482400000002599,
                "postcode": "N1 3JD",
                "region": "Greater London"
            },
            "created": "2015-08-22T12:20:18Z",
            "group_id": "grp_00008zIcpbBOaAr7TTP3sv",
            "id": "merch_00008zIcpbAKe8shBxXUtl",
            "logo": "https://pbs.twimg.com/profile_images/527043602623389696/68_SgUWJ.jpeg",
            "emoji": "🍞",
            "name": "The De Beauvoir Deli Co.",
            "category": "eating_out"
        }
    }
}
```
