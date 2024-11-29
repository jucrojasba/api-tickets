
# Tickets : API

This api is made for manage ticket creation


https://api-tickets-cbbg.onrender.com/


## Authors

- [@HernanDavidA](https://www.github.com/HernanDavidA)
- [@jucrojasba ](https://www.github.com/jucrojasba)
- [@Mosquera131 ](https://www.github.com/Mosquera131)
- [@SanDaws ](https://www.github.com/SanDaws )


## Installation and running this project

git clone this project

```bash
git clone https://github.com/jucrojasba/api-tickets.git
  cd api-tickets
```
install gems
```bash
gem install
```
run project
```bash
rails s
```

    
## API Reference

#### Get all items

```http
  GET events/:event_id/tickets/summary
```

| Parameter | Type     | Description                |Response|
| :-------- | :------- | :------------------------- |:----------|
| `:event_id` | `int` | **Required**. event  that requires summary |json|

#### Succed Response Example:
```JSON
        event_id: 
        available_tickets: 
        reserved_tickets: 
        sold_tickets:
        canceled_tickets: 
        total_tickets: 
```

#### Get item

```http
  GET events/:event_id/tickets/:quantity
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `:event_id`      | `int` | **Required**. event that you need tickets for   |
| `:quantity`      | `int` | **Required**. number of tickets needed|

#### Succed Response Example:
```JSON
        event_id: 
        tickets:
                { id:  , serial: }
```


```http
  GET /tickets/:id/logs
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of item to fetch |

```http
  POST /events/:event_id/tickets
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. id of an event that need to generate all their tickets from ticket_quantity  |

```http
  PATCH tickets/:ticket_id/status
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. ticket to patch |

#### Requieres
body whit id of status :
| Parameter | Type     | 
| :-------- | :------- | 
| `1`      | `available` |
| `2`      | `reserved` |
| `3`      | `sold` |
| `4`      | `canceled` |








## Used By

This project is used by the following companies:

- [Event-system](https://github.com/Riwi-io-Medellin/Rails-event-system )


