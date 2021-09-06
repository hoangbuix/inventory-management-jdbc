package com.hoangbuix.dev.model.mapper;

import com.hoangbuix.dev.entity.AuthEntity;

import java.sql.ResultSet;
import java.sql.SQLException;

public class AuthMapper implements RowMapper<AuthEntity> {
    @Override
    public AuthEntity mapRow(ResultSet resultSet) {
        try {
            AuthEntity auth = new AuthEntity();
            auth.setId(resultSet.getInt("id"));
            return auth;
        }catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
