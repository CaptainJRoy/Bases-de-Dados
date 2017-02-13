
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.bson.Document;
import org.bson.types.ObjectId;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author fabiobaiao
 */
public class Main {
    public static void main(String[] args){
        Map<Integer, ObjectId> idsPassageiros = migratePassageiros();
        Map<Integer, ObjectId> idsComboios = migrateComboios();
        Map<Integer, ObjectId> idsEstacoes = migrateEstacoes();
        Map<Integer, ObjectId> idsViagens = migrateViagens(idsComboios, idsEstacoes);
        migrateBilhetes(idsViagens, idsPassageiros, idsComboios);
    }
    
    private static Map<Integer, ObjectId> migratePassageiros(){
        Connection conn = null;
        Map<Integer, ObjectId> idsPassageiros = new HashMap<>();
        try{
            conn = Connect.connect();
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery("SELECT * FROM Passageiro");
            List<Document> documents = new ArrayList<>();
            while (rs.next()){
                int id = rs.getInt("id");
                ObjectId o = new ObjectId();
                idsPassageiros.put(id, o);
                Document d = new Document("_id", o)
                        .append("nome", rs.getString("nome"))
                        .append("email", rs.getString("email"))
                        .append("password", rs.getString("palavrapasse"));
                
                documents.add(d);
            }
            MongoClient mongoClient = new MongoClient();
            MongoDatabase database = mongoClient.getDatabase("comboios");
            MongoCollection<Document> collection = database.getCollection("passageiro");
            collection.insertMany(documents);
            mongoClient.close();
        }
        catch (ClassNotFoundException | SQLException e){
            System.out.println(e.getMessage());
        }
        finally{
            Connect.close(conn);
        }
        return idsPassageiros;
    }
    
    private static Map<Integer, ObjectId> migrateComboios(){
        Connection conn = null;
        Map<Integer, ObjectId> idsComboios = new HashMap<>();
        try{
            conn = Connect.connect();
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery("SELECT * FROM Comboio");
            List<Document> documents = new ArrayList<>();
            while (rs.next()){
                int id = rs.getInt("id");
                List<Integer> lugares = migrateLugares(id);
                ObjectId o = new ObjectId();
                idsComboios.put(id, o);
                Document d = new Document("_id", o)
                        .append("observacoes", rs.getString("observacoes"))
                        .append("lugares", lugares);
                
                documents.add(d);
            }
            MongoClient mongoClient = new MongoClient();
            MongoDatabase database = mongoClient.getDatabase("comboios");
            MongoCollection<Document> collection = database.getCollection("comboio");
            collection.insertMany(documents);
            mongoClient.close();
        }
        catch (ClassNotFoundException | SQLException e){
            System.out.println(e.getMessage());
        }
        finally{
            Connect.close(conn);
        }
        return idsComboios;
    }
    
    private static List<Integer> migrateLugares(int id){
        List<Integer> lugares = new ArrayList<>();
        Connection conn = null;
        try{
            conn = Connect.connect();
            PreparedStatement stm = conn.prepareStatement("SELECT * FROM LugarComboio WHERE comboio_id = ?");
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            while(rs.next()){
                lugares.add(rs.getInt("NumeroLugar"));
            }
            
        } catch (SQLException | ClassNotFoundException ex) {
            System.out.println(ex.getMessage());
        }
        finally{
            Connect.close(conn);
        }
        return lugares;
    }
    
    private static Map<Integer, ObjectId> migrateEstacoes(){
        Connection conn = null;
        Map<Integer, ObjectId> idsEstacoes = new HashMap<>();
        try{
            conn = Connect.connect();
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery("SELECT * FROM Estacao");
            List<Document> documents = new ArrayList<>();
            while (rs.next()){
                int id = rs.getInt("id");
                ObjectId o = new ObjectId();
                idsEstacoes.put(id, o);
                Document d = new Document("_id", o)
                        .append("cidade", rs.getString("cidade"))
                        .append("nome", rs.getString("nome"));
                
                documents.add(d);
            }
            MongoClient mongoClient = new MongoClient();
            MongoDatabase database = mongoClient.getDatabase("comboios");
            MongoCollection<Document> collection = database.getCollection("estacao");
            collection.insertMany(documents);
            mongoClient.close();
        }
        catch (ClassNotFoundException | SQLException e){
            System.out.println(e.getMessage());
        }
        finally{
            Connect.close(conn);
        }
        return idsEstacoes;
    }
    
    private static Map<Integer, ObjectId> migrateViagens(Map<Integer, ObjectId> idsComboios, Map<Integer, ObjectId> idsEstacoes){
        Connection conn = null;
        Map<Integer, ObjectId> idsViagens = new HashMap<>();
        try{
            conn = Connect.connect();
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery("SELECT * FROM Viagem");
            List<Document> documents = new ArrayList<>();
            while (rs.next()){
                int id = rs.getInt("id");
                ObjectId o = new ObjectId();
                idsViagens.put(id, o);
                Document d = new Document("_id", o)
                        .append("comboio", idsComboios.get(rs.getInt("comboio_id")))
                        .append("horapartida", rs.getTime("horapartida"))
                        .append("horachegada", rs.getTime("horachegada"))
                        .append("origem", idsEstacoes.get(rs.getInt("origem")))
                        .append("destino", idsEstacoes.get(rs.getInt("destino")));
                
                documents.add(d);
            }
            MongoClient mongoClient = new MongoClient();
            MongoDatabase database = mongoClient.getDatabase("comboios");
            MongoCollection<Document> collection = database.getCollection("viagem");
            collection.insertMany(documents);
            mongoClient.close();
        }
        catch (ClassNotFoundException | SQLException e){
            System.out.println(e.getMessage());
        }
        finally{
            Connect.close(conn);
        }
        return idsViagens;
    }
    
    private static void migrateBilhetes(Map<Integer, ObjectId> idsViagens, Map<Integer, ObjectId> idsPassageiros, Map<Integer, ObjectId> idsComboios){
        Connection conn = null;
        try{
            conn = Connect.connect();
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery("SELECT * FROM Bilhete");
            List<Document> documents = new ArrayList<>();
            while (rs.next()){
                int id = rs.getInt("id");
                ObjectId o = new ObjectId();
                Document d = new Document("_id", o)
                        .append("passageiro", idsPassageiros.get(rs.getInt("passageiro_id")))
                        .append("viagem", idsViagens.get(rs.getInt("viagem_id")))
                        .append("dataviagem", rs.getDate("dataviagem"))
                        //.append("comboio", idsComboios.get(rs.getInt("lugarcomboio_comboio_id")))
                        .append("lugar", rs.getInt("lugarcomboio_numerolugar"));
                
                documents.add(d);
            }
            MongoClient mongoClient = new MongoClient();
            MongoDatabase database = mongoClient.getDatabase("comboios");
            MongoCollection<Document> collection = database.getCollection("bilhete");
            collection.insertMany(documents);
            mongoClient.close();
        }
        catch (ClassNotFoundException | SQLException e){
            System.out.println(e.getMessage());
        }
        finally{
            Connect.close(conn);
        }
    }
}
