package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.

func do(seconds int, action ...any) {
	log.Println(action...)
	randomMillis := 500*seconds + rand.Intn(500*seconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

// Order represents a meal order placed by a customer and taken by a cook.
// When the meal is finished, the cook will send the finished order through
// the reply channel. Each order has a unique id, safely incremented using
// an atomic counter.
type Order struct {
	id         uint64
	customer   string
	reply      chan *Order
	preparedBy string
}

var nextOrderID atomic.Uint64

func newOrder(customer string) *Order {
	return &Order{
		id:       nextOrderID.Add(1),
		customer: customer,
		reply:    make(chan *Order, 1),
	}
}

// The waiter is represented by a buffered channel of orders with capacity 3.
// The waiter can only hold 3 outstanding orders at a time.
var waiter = make(chan *Order, 3)

// cook spends their time fetching orders from the waiter channel,
// cooking the requested meal, and sending the meal back through
// the order's reply channel. The cook personally delivers the meal.
func cook(name string) {
	log.Println(name, "starting work")
	for order := range waiter {
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		// Cook personally delivers the meal to the customer
		order.reply <- order
	}
}

// customer eats five meals and then goes home. Each time they enter the
// restaurant, they place an order with the waiter. If the waiter is too
// busy (channel full for more than 7000 ms), the customer will wait and
// come back later (between 2500 and 5000 ms). If the order does get placed,
// they will wait as long as necessary for the meal to be cooked and delivered.
func customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()

	mealsEaten := 0
	for mealsEaten < 5 {
		order := newOrder(name)
		log.Println(name, "placed order", order.id)

		// Try to place order with 7 second timeout
		select {
		case waiter <- order:
			// Order placed successfully, wait for meal to be cooked and delivered
			meal := <-order.reply
			// Eat for 1-2 seconds (1000-2000 ms)
			do(2, name, "eating cooked order", meal.id,
				"prepared by", meal.preparedBy)
			mealsEaten++
		case <-time.After(7 * time.Second):
			// Waiter too busy (took more than 7000 ms), come back later (2.5-5 seconds)
			do(5, name, "waiting too long, abandoning order", order.id)
		}
	}
	log.Println(name, "going home")
}

func main() {
	// Seed random number generator
	rand.Seed(time.Now().UnixNano()) //CAN REMOVE?????

	customers := []string{
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}

	// WaitGroup to track when all customers are done
	var wg sync.WaitGroup

	// Start the three cooks
	cooks := []string{"Remy", "Colette", "Linguini"}
	for _, cookName := range cooks {
		go cook(cookName)
	}

	// Start all customers - each customer will decrement the WaitGroup when done
	for _, customerName := range customers {
		wg.Add(1)
		go customer(customerName, &wg)
	}

	// Wait for all customers to finish (go home) using WaitGroup
	wg.Wait()

	// Cleanup nicely - close waiter channel to signal cooks to stop
	log.Println("Restaurant closing")
	close(waiter)
}
