1) What is the difference between concurrency and parallelism?

Concurrency is the ability of a program to manage multiple tasks at once by interleaving their execution. Tasks may overlap in time but do not necessarily run simultaneously.

Parallelism is the simultaneous execution of multiple tasks on multiple CPU cores. It requires hardware support and involves true simultaneous computation.


2) What is the difference between a thread and a task in Java? Give an example.

A thread is an actual execution unit managed by the JVM and the operating system. You create it, start it, and control its lifecycle directly.

A task is a unit of work (a Runnable or Callable) submitted to an executor. The executor chooses which thread runs the task.

Examples:

Thread
new Thread(() -> doWork()).start();

Task
executor.submit(() -> doWork());

3) What happens if you invoke a method on a thread that has terminated in Java? If you call an entry on a task that has terminated in Ada?

In Java, a terminated thread cannot be restarted. Calling start() again throws IllegalThreadStateException. Other methods such as isAlive(), getState(), or join() are allowed and simply report that the thread has finished.

In Ada, a terminated task cannot accept entries. Calling an entry on such a task raises Tasking_Error, since a terminated task cannot participate in further rendezvous.

4) Explain, for Ada, Java, and Go, when, exactly, a program terminates. That is, will it terminate when the main thread finishes, or will it wait for certain other threads to finish first?

In Java, the program terminates only after the main thread and all non‑daemon threads finish. Daemon threads do not keep the JVM alive.

In Go, the program terminates as soon as the main goroutine returns. Other goroutines are not waited on and stop immediately.

In Ada, the program terminates when the environment task (main program) and all of its dependent tasks have completed. Ada waits for tasks unless they are explicitly aborted or never activated.

5) In Go, what is the difference between a buffered and unbuffered channel? Provide an example of when you would use each.

A buffered channel has capacity. Sends succeed until the buffer is full, and receives succeed while the buffer has elements. It allows producers and consumers to run at different speeds. Example: a worker pool where tasks accumulate in a channel of size N.

An unbuffered channel has no capacity. Sends block until a receiver is ready, and receives block until a sender is ready. It enforces a direct handoff.

Example: synchronizing two goroutines so one waits for a signal from the other.


6) Explain the difference between a mutex and a read-write mutex (RWMutex) in Go. When would you choose one over the other?

A mutex provides exclusive access: only one goroutine may hold the lock, regardless of whether it is reading or writing. It is best when writes are frequent or when simplicity is preferred.

An RWMutex allows multiple concurrent readers but requires exclusive access for writers. It improves performance when reads dominate.

Use a mutex for frequent writes or simple critical sections; use an RWMutex when the data is mostly read and you want concurrent readers.


7) What happens if you try to read from or write to a closed channel in Go? How can you detect if a channel is closed?

Reading from a closed channel is allowed: you get the element type’s zero value, and the receive reports ok = false in the v, ok := <-ch form. Writing to a closed channel panics. The standard way to detect closure is using that two‑value receive; ok is false only when the channel has been closed and fully drained.


8) Describe the select statement in Go and how it differs from a switch statement. What happens when multiple channels in a select are ready simultaneously?

A select waits on multiple channel operations and executes one that is ready. Each case must be a send or receive. It blocks until at least one operation can proceed.

A switch matches values and does not involve channels or blocking.

If multiple select cases are ready simultaneously, Go chooses one at random (fairly). Only one case executes.