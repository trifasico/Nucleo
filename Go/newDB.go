package main

import (
	"context"
	"fmt"
	"log"
	"strconv"

	//"reflect"
	"cloud.google.com/go/firestore"
	"google.golang.org/api/iterator"
)

var pessoas []map[string]interface{}

//Logins são os logins
var Logins []Login

//Kits são os logins
var Kits []Kit

type kitp struct {
	k []bool
}

type item struct {
	name    string
	Psocio  string
	PNsocio string
}

//Login são os logins
type Login struct {
	aluno       string
	nome        string
	password    string
	mail        string
	socio       string
	telemovel   string
	cotas       bool
	visitas     []string
	visitasConf []string
	posts       []int64
	kits        []kitp
	more        string
}

//Kit são os logins
type Kit struct {
	title    string
	text     string
	date     string
	hour     string
	image    string
	items    []item
	itemsQ   []int64
	levou    []string
	pagou    []string
	quemquer []string
}

//PeopleRead lê as cenas todas e exporta e guarda no array de pessoas
func PeopleRead(ctx context.Context, client *firestore.Client, collect string) {
	iter := client.Collection(collect).Documents(ctx)
	for {
		var pp Login
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		docdata := doc.Data() // getDocData()
		pessoas = append(pessoas, docdata)
		pp.aluno = doc.Ref.ID //.(string)
		pp.nome = docdata["Username"].(string)
		pp.password = docdata["Password"].(string)
		pp.mail = docdata["mail"].(string)
		pp.socio = docdata["socio"].(string)
		pp.telemovel = docdata["telemovel"].(string)
		pp.cotas = docdata["cotas"].(bool)

		if docdata["visitas"] != nil {
			for _, url := range docdata["visitas"].([]interface{}) {
				pp.visitas = append(pp.visitas, url.(string))
			}
		}
		if docdata["visitasConf"] != nil {
			for _, url := range docdata["visitasConf"].([]interface{}) {
				pp.visitasConf = append(pp.visitasConf, url.(string))
			}
		}
		if docdata["Posts"] != nil {
			for _, url := range docdata["Posts"].([]interface{}) {
				pp.posts = append(pp.posts, url.(int64))
			}
		}
		if docdata["Kits"] != nil {
			aa := docdata["Kits"].(map[string]interface{})
			for i := 0; i < 100; i++ {
				var a kitp
				//a.k = append(a.k, false)
				if aa[strconv.Itoa(i)] != nil {
					ab := aa[strconv.Itoa(i)].([]interface{})
					for j := 0; j < len(ab); j++ {
						if ab[j] != nil {
							xx := ab[j].(bool)
							a.k = append(a.k, xx)
						}
					}
					pp.kits = append(pp.kits, a)
				} else {
					pp.kits = append(pp.kits, a)
				}
			}
		}
		Logins = append(Logins, pp)
	}
}

//KitsRead le os kits todos
func KitsRead(ctx context.Context, client *firestore.Client, collect string) {

	iter := client.Collection(collect).Documents(ctx)
	for {
		var pk Kit
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			log.Fatalf("Failed to iterate: %v", err)
		}
		docdata := doc.Data() // getDocData()

		pk.title = docdata["title"].(string)
		pk.text = docdata["text"].(string)
		pk.date = docdata["date"].(string)
		pk.hour = docdata["hour"].(string)
		pk.image = docdata["image"].(string)

		if docdata["itemsQ"] != nil {
			for _, url := range docdata["itemsQ"].([]interface{}) {
				pk.itemsQ = append(pk.itemsQ, url.(int64))
			}
		}
		if docdata["levou"] != nil {
			for _, url := range docdata["levou"].([]interface{}) {
				pk.levou = append(pk.levou, url.(string))
			}
		}
		if docdata["pagou"] != nil {
			for _, url := range docdata["pagou"].([]interface{}) {
				pk.pagou = append(pk.pagou, url.(string))
			}
		}
		if docdata["quemquer"] != nil {
			for _, url := range docdata["quemquer"].([]interface{}) {
				pk.quemquer = append(pk.quemquer, url.(string))
			}
		}

		if docdata["items"] != nil {
			aa := docdata["items"].(map[string]interface{})
			//var pk []item
			for i := 0; i < 100; i++ {
				var a item
				if aa[strconv.Itoa(i)] != nil {
					ab := aa[strconv.Itoa(i)].([]interface{})

					a.name = ab[0].(string)
					a.Psocio = ab[1].(string)
					a.PNsocio = ab[2].(string)
					//fmt.Println(a)
					pk.items = append(pk.items, a)
				}
			}
		}
		Kits = append(Kits, pk)
	}
}

//Kits2Excel exporta os kits para o excel
func Kits2Excel(KK []Kit, LL []Login) {
	fmt.Println("Kits")
	excel(KK[0], LL, 0)

	/*for i := 0; i < len(KK); i++ {
		excel(KK[i], LL, i)
		//fmt.Println("##################################################")
	}*/
}
