package main

import (
    "fmt"
    "log"

    "github.com/bwmarrin/discordgo"
    "github.com/git-go/git"
)

func main() {
    token := "***************"

    dg, err := discordgo.New(token)
    if err != nil {
        log.Fatal(err)
    }

    repo, err := git.PlainOpen("/path/to/your/repo")
    if err != nil {
        log.Fatal(err)
    }

    dg.AddHandler(func(s *discordgo.Session, m *discordgo.MessageCreate) {
        if m.Content == "!git pull" {
            err := pull(repo)
            if err != nil {
                log.Println("Ошибка при выполнении git pull:", err)
                s.ChannelMessageSend(m.ChannelID, fmt.Sprintf("Ошибка при выполнении git pull: %s", err))
                return
            }

            s.ChannelMessageSend(m.ChannelID, "Git pull выполнен успешно!")
        }
    })

    err = dg.Open()
    if err != nil {
        log.Fatal(err)
    }

    defer dg.Close()
    <-make(chan struct{})
}

func pull(repo *git.Repository) error {
    err := repo.Fetch(&git.FetchOptions{})
    if err != nil {
        return err
    }

    err = repo.Pull(&git.PullOptions{})
    if err != nil {
        return err
    }

    return nil
}
