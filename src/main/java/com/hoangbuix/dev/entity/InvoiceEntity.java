package com.hoangbuix.dev.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

@Setter
@Getter
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "invoice")
@Table(name = "invoice")
public class InvoiceEntity extends BaseEntity {
    @Column(name = "code")
    private String code;

    @Column(name = "type")
    private int type;

    @Column(name = "qty")
    private int qty;

    @Column(name = "price")
    private BigDecimal price;

    @Column(name = "to_date")
    private Date toDate;

    @Column(name = "from_date")
    private Date fromDate;

//    @JsonIgnore
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "product_id")
//    private ProductInfoEntity productInfos;

    @Column(name = "product_id")
    private int productId;
}
