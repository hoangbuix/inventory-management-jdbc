package com.hoangbuix.dev.validate;

import com.hoangbuix.dev.entity.CategoryEntity;
import com.hoangbuix.dev.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

@Component
public class CategoryValidator implements Validator {
    @Autowired
    private CategoryService categoryService;

    @Override
    public boolean supports(Class<?> clazz) {
        return clazz == CategoryEntity.class;
    }

    @Override
    public void validate(Object target, Errors errors) {
        CategoryEntity category = (CategoryEntity) target;
        ValidationUtils.rejectIfEmpty(errors, "code", "msg.required");
        ValidationUtils.rejectIfEmpty(errors, "name", "msg.required");
        ValidationUtils.rejectIfEmpty(errors, "description", "msg.required");
        if (category.getCode() != null) {
            CategoryEntity results = categoryService.findByCode(category.getCode());
            if (results != null) {
                if (category.getId() != null && category.getId() != 0) {
                    if (results.getId() != category.getId()) {
                        errors.rejectValue("code", "msg.code.exist");
                    }
                } else {
                    errors.rejectValue("code", "msg.code.exist");
                }
            }
        }
    }
}
