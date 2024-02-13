package com.github.nsmolenskii.observability.app

import jakarta.annotation.PostConstruct
import jakarta.annotation.PreDestroy
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import org.springframework.stereotype.Component
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.bodyToMono
import reactor.core.Disposable
import reactor.core.publisher.Flux
import reactor.core.publisher.Mono
import reactor.core.scheduler.Schedulers
import java.net.URI
import java.time.Duration

@SpringBootApplication
@EnableConfigurationProperties(GreetingProperties::class)
class SandboxApplication

fun main(args: Array<String>) {
    runApplication<SandboxApplication>(*args)
}

data class Greet(val greeting: String)

@RestController
class GreetingsController {
    @GetMapping("/greeting")
    fun greet(name: String = "there") = Greet("Hi $name!")
}

@ConfigurationProperties(prefix = "greetings")
data class GreetingProperties(
        val urls: List<URI>,
        val interval: Duration = Duration.ofSeconds(1)
)

@Component
class GreetingsScheduler(
        private val builder: WebClient.Builder,
        private val properties: GreetingProperties
) {
    private val log = LoggerFactory.getLogger(javaClass)

    private lateinit var disposable: Disposable

    @PostConstruct
    fun start(): Unit = with(properties) {
        disposable = Flux.interval(interval)
                .flatMap { Flux.fromIterable(urls) }
                .flatMap { url -> url.greet().onErrorComplete() }
                .subscribeOn(Schedulers.parallel())
                .subscribe()
    }

    @PreDestroy
    fun stop() = disposable.dispose()
    private fun URI.greet(): Mono<Void> =
            builder.baseUrl(toASCIIString()).build()
                    .get().uri("/greeting")
                    .retrieve()
                    .bodyToMono<Greet>()
                    .doOnSuccess { greet -> log.info("service {} succeed with {}", toASCIIString(), greet) }
                    .doOnError { error -> log.error("service {} failed with {}", toASCIIString(), error.message) }
                    .then()
}


