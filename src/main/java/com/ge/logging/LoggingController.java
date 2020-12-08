package com.ge.logging;

import javax.websocket.server.PathParam;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
public class LoggingController {

    Logger logger = LoggerFactory.getLogger(LoggingController.class);

    @PostMapping(path = "/logs/{level}", consumes = MediaType.TEXT_PLAIN_VALUE)
    @ResponseStatus(HttpStatus.OK)
    public String addLogEntry(@PathVariable String level, @RequestBody String message) {
        switch (level) {
            case "trace":
                logger.trace(message);
                break;
            case "debug":
                logger.debug(message);
                break;
            case "info":
                logger.info(message);
                break;
            case "warn":
                logger.warn(message);
                break;
            case "error":
                logger.error(message);
                break;
            default:
                logger.error("Unrecognized level {}", level);
        }

        try {
            return InetAddress.getLocalHost().getHostName();
        } catch (UnknownHostException uhex) {
            return "unkonwn host";
        }

    }

}
